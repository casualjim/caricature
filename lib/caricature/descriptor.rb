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

  # Describes a ruby object.
  class RubyObjectDescriptor < TypeDescriptor

    # collects all the members that are defined by this class
    def initialize_instance_members_for(klass)
      @instance_members += (klass.instance_methods - Object.instance_methods).collect { |mn| MemberDescriptor.new(mn) }
    end

    # collects all the members that aren't a member of Object.singleton_methods
    def initialize_class_members_for(klass)
      @class_members += klass.methods(false).collect { |mn| MemberDescriptor.new(mn) }
    end

  end  

end