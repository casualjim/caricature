module Caricature

  # Contains the logic to collect members from a CLR type
  module ClrMemberCollector

    private
      # collects the instance members for a CLR type.
      # makes sure it can handle indexers for properties etc.
      def build_member_collection(instance_member=true)

        mem = []
        mem += @methods.collect do |mi|
          MemberDescriptor.new(mi.name.underscore, mi.return_type, instance_member) unless event?(mi.name)
        end
        @properties.each do |pi|
          prop_name = property_name_from(pi)
          mem << MemberDescriptor.new(prop_name, pi.property_type, instance_member)
          mem << MemberDescriptor.new("__setitem__", nil, instance_member) if prop_name == "__getitem__"
          mem << MemberDescriptor.new("#{prop_name}=", nil, instance_member) if pi.can_write and prop_name != "__getitem__"
        end
        (@events||[]).each do |ei|
          mem << MemberDescriptor.new("add_#{ei.name}", System::Void.to_clr_type, instance_member)
          mem << MemberDescriptor.new("remove_#{ei.name}", System::Void.to_clr_type, instance_member)
       end
        mem
      end

      # indicates if this member is an event
      def event?(name)
        (@events||[]).any? { |en| /^(add|remove)_#{en}/i =~ name }
      end

      # gets the property name from the +PropertyInfo+
      # when the property is an indexer it will return +[]+
      def property_name_from(property_info)
        return property_info.name.underscore if property_info.get_index_parameters.empty?
        "__getitem__"
      end

      # the binding flags for instance members of a CLR type
      def instance_flags
        System::Reflection::BindingFlags.public | System::Reflection::BindingFlags.instance
      end

      # the binding flags for class members of a CLR type
      def class_flags
        System::Reflection::BindingFlags.public | System::Reflection::BindingFlags.static
      end

  end

  class ClrEventDescriptor

    attr_reader :event_name
    
    def initialize(event_name)
      @event_name = event_name
    end

    def to_s
      "<#{self.class}:#{object_id} @event_name=\"#{event_name}\">"
    end
  end

  # describes clr interfaces.
  # Because CLR interfaces can't have static members this descriptor does not collect any class members
  class ClrInterfaceDescriptor < TypeDescriptor

    include ClrMemberCollector

    # collects instance members on this interface
    # it will collect properties, methods and property setters
    def initialize_instance_members_for(klass)
      clr_type = klass.to_clr_type

      @properties = clr_type.collect_interface_properties
      @methods = clr_type.collect_interface_methods
      @events = clr_type.collect_interface_events

      @instance_members = build_member_collection
    end

    # this method is empty because an interface can't have static members
    def initialize_class_members_for(klass); end

  end


  # Describes a CLR class type. it collects the properties and methods on an instance as well as on a static level
  class ClrClassDescriptor < TypeDescriptor

    include ClrMemberCollector

    # collects all the instance members of the provided CLR class type
    def initialize_instance_members_for(klass)
      clr_type = klass.to_clr_type

      @methods = clr_type.get_methods(instance_flags)
      @properties = clr_type.get_properties(instance_flags)

      @instance_members = build_member_collection
    end

    # collects all the static members of the provided CLR class type
    def initialize_class_members_for(klass)
      clr_type = klass.to_clr_type

      @methods = clr_type.get_methods(class_flags)
      @properties = clr_type.get_properties(class_flags)

      @class_members = build_member_collection false
    end

  end

end