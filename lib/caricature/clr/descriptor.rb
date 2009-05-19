module Caricature

  # describes clr interfaces.
  # Because CLR interfaces can't have static members this descriptor does not collect any class members
  class ClrInterfaceDescriptor < TypeDescriptor

    # collects instance members on this interface
    # it will collect properties, methods and property setters
    def initialize_instance_members_for(klass)
      clr_type = klass.to_clr_type

      properties = clr_type.collect_interface_properties
      methods = clr_type.collect_interface_methods

      @instance_members += methods.collect { |mi| MemberDescriptor.new(mi.name.underscore, mi.return_type) }
      @instance_members += properties.collect { |pi| MemberDescriptor.new(pi.name.underscore, pi.property_type) }
      @instance_members += properties.select { |pi| pi.can_write }.collect { |pi| MemberDescriptor.new("#{pi.name.underscore}=", nil) }
    end

    # this method is empty because an interface can't have static members
    def initialize_class_members_for(klass); end

  end


  # Describes a CLR class type. it collects the properties and methods on an instance as well as on a static level
  class ClrClassDescriptor < TypeDescriptor

    # collects all the instance members of the provided CLR class type
    def initialize_instance_members_for(klass)
      clr_type = klass.to_clr_type

      methods = Workarounds::ReflectionHelper.get_instance_methods(clr_type)
      properties = Workarounds::ReflectionHelper.get_instance_properties(clr_type)

      @instance_members += methods.collect { |mi| MemberDescriptor.new(mi.name.underscore, mi.return_type) }
      @instance_members += properties.collect { |pi| MemberDescriptor.new(pi.name.underscore, pi.property_type) }
      @instance_members += properties.select{|pi| pi.can_write }.collect { |pi| MemberDescriptor.new("#{pi.name.underscore}=", nil) }
    end

    # collects all the static members of the provided CLR class type
    def initialize_class_members_for(klass)
      clr_type = klass.to_clr_type

      @class_members += clr_type.get_methods.select { |mi| mi.is_static }.collect  { |mi| MemberDescriptor.new(mi.name.underscore, mi.return_type, false) }
    end

  end

end