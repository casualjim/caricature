module Caricature

  # Describes a class/type so it can be proxied more easily
  # This is the base class from which other more specialised descriptors can be
  # used to provide the metadata need to generate the proxy classes
  class TypeDescriptor

    # Gets the instance members of the described type/class
    attr_reader :instance_members

    # Gets the class members for the described type/class
    attr_reader :class_members

    # initializes a new instance of a type descriptor
    def initialize(klass)
      @instance_members = []
      @class_members = []

      unless klass == :in_unit_test_for_class
        initialize_instance_members_for klass
        initialize_class_members_for klass
      end
    end

    # collects the instance members of the provided type
    def initialize_instance_members_for(klass)
      raise NotImplementedError.new("Override in implementing class")
    end

    # collects the class members of the provided type
    def initialize_class_members_for(klass)
      raise NotImplementedError.new("Override in implementing class")
    end
  end

  # Describes a member of a class
  # this contains the metadata needed to generate the member
  # and perhaps a default value for the property type if necessary
  class MemberDescriptor

    # the return type of this member
    attr_reader :return_type

    # the name of this member
    attr_reader :name

    # initializes a nem instance of member descriptor
    def initialize(name, return_type=nil, is_instance_member=true)
      @name, @return_type, @instance_member = name, return_type, is_instance_member
    end

    # indicates whether this member is a class member or an instance member
    def instance_member?
      @instance_member
    end

  end

  # describes clr interfaces.
  # Because CLR interfaces can't have static members this descriptor does not collect any class members
  class ClrInterfaceDescriptor < TypeDescriptor

    # initializes a new instance of the CLR interface descriptor with the provided type
    def initialize(klass)
      super
    end

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

  # Describes a ruby object. at this moment it will only detect methods that aren't overrides of Object members
  class RubyObjectDescriptor < TypeDescriptor

    # collects all the members that aren't member of Object.instance_methods
    def initialize_instance_members_for(klass)
      @instance_members += (klass.instance_methods - Object.instance_methods).collect { |mn| MemberDescriptor.new(mn) }
    end

    # collects all the members that aren't a member of Object.singleton_methods
    def initialize_class_members_for(klass)

    end

  end

  # Describes a CLR class type. it collects the properties and methods on an instance as well as on a static level 
  class ClrClassDescriptor < TypeDescriptor

    # collects all the instance members of the provided CLR class type
    def initialize_instance_members_for(klass)
      clr_type = klass.to_clr_type

      @instance_members += clr_type.get_methods.select { |pi| !pi.is_static }.collect { |mi| MemberDescriptor.new(mi.name.underscore, mi.return_type) }
      @instance_members += clr_type.get_properties.collect { |pi| MemberDescriptor.new(pi.name.underscore, pi.property_type) }
      @instance_members += clr_type.get_properties.select{|pi| pi.can_write }.collect { |pi| MemberDescriptor.new("#{pi.name.underscore}=", nil) }
    end

    # collects all the static members of the provided CLR class type
    def initialize_class_members_for(klass)

    end

  end

end