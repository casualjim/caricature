module Caricature

  # Contains the logic to collect members from a CLR type
  module ClrMemberCollector

    attr_reader :class_events, :events

    private
    # collects the instance members for a CLR type.
    # makes sure it can handle indexers for properties etc.
    def build_member_collections(context={}, instance_member=true)

      build_event_collection(context, instance_member)

      mem = []
      mem += build_method_collection(context, instance_member)
      mem += build_property_collection(context, instance_member)
      mem
    end

    def build_property_collection(context, instance_member)
      context[:properties].inject([]) do |res, pi|
        prop_name = property_name_from(pi)
        res << MemberDescriptor.new(prop_name, pi.property_type, instance_member)
        res << MemberDescriptor.new("set_Item", nil, instance_member) if prop_name == "get_Item"
        res << MemberDescriptor.new("#{prop_name}=", nil, instance_member) if pi.can_write and prop_name != "get_Item"
        res
      end
    end

    def build_method_collection(context, instance_member)
      context[:methods].inject([]) do |meths, mi|
        meths << MemberDescriptor.new(mi.name.underscore, mi.return_type, instance_member) unless event?(mi.name, instance_member)
        meths
      end
    end

    def build_event_collection(context, instance_member)
      context[:events].inject(evts=[]) { |evc, ei| evc << ClrEventDescriptor.new(ei.name, instance_member) }
      (instance_member ? @events = evts : @class_events = evts)
    end

    # indicates if this member is an event
    def event?(name, instance_member)
      ((instance_member ? @events : @class_events)||[]).any? { |en| /^(add|remove)_#{en.event_name}/i =~ name }
    end

    # gets the property name from the +PropertyInfo+
    # when the property is an indexer it will return +[]+
    def property_name_from(property_info)
      return property_info.name.underscore if property_info.get_index_parameters.empty?
      "get_Item"
    end

    # the binding flags for instance members of a CLR type
    def instance_flags
      System::Reflection::BindingFlags.public | System::Reflection::BindingFlags.instance
    end

    # the binding flags for class members of a CLR type
    def class_flags
      System::Reflection::BindingFlags.public | System::Reflection::BindingFlags.static
    end

    def event_flags
      non_public_flag | instance_flags
    end

    def class_event_flags
      non_public_flag | class_flags
    end

    def non_public_flag
      System::Reflection::BindingFlags.non_public
    end

  end

  class ClrEventDescriptor

    attr_reader :event_name

    def initialize(event_name, instance_member=true)
      @event_name, @instance_member = event_name, instance_member
    end

    def instance_member?
      @instance_member
    end

    def add_method_name
      "add_#{event_name}"
    end

    def remove_method_name
      "remove_#{event_name}"
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

      context = {}
      context[:properties] = clr_type.collect_interface_properties
      context[:methods] = clr_type.collect_interface_methods
      context[:events] = clr_type.collect_interface_events

      @instance_members = build_member_collections context
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

      context = {}
      context[:methods] = clr_type.get_methods(instance_flags)
      context[:properties] = clr_type.get_properties(instance_flags)
      context[:events] = clr_type.get_events(event_flags)

      @instance_members = build_member_collections context
    end

    # collects all the static members of the provided CLR class type
    def initialize_class_members_for(klass)
      clr_type = klass.to_clr_type

      context = {}
      context[:methods] = clr_type.get_methods(class_flags)
      context[:properties] = clr_type.get_properties(class_flags)
      context[:events] = clr_type.get_events(class_event_flags)

      @class_members = build_member_collections context, false
    end

  end

end