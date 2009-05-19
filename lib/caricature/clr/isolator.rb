module Caricature

  # A proxy to CLR objects that records method calls.
  # this implements all the public instance methods of the class when you use it in ruby code
  # When you use it in a CLR class you're bound to CLR rules and it only overrides the methods
  # that are marked as virtual. We also can't isolate static or sealed types at the moment.
  class ClrIsolator < Isolator


    # Implementation of the template method that creates
    # an isolator for a class defined in a CLR language.
    def initialize(context)
      super
      instance = nil
      sklass = context.subject
      unless context.subject.respond_to?(:class_eval)
        sklass = context.subject.class
        instance = context.subject
      end
      @descriptor = ClrClassDescriptor.new sklass
      build_isolation sklass, (instance || sklass.new)
    end

    # initializes the messaging strategy for the isolator
    def initialize_messenger
      @context.messenger = ClrClassMessenger.new @context.expectations, @subject
    end

    # builds the Isolator class for the specified subject
    def  create_isolation_for(subj)
      members = @descriptor.instance_members

      klass = Object.const_set(class_name(subj), Class.new(subj))
      klass.class_eval do

        include Interception

        # access to the proxied subject
        def ___super___
          isolation_context.instance
        end

        members.each do |mem|
          nm = mem.name.to_s.to_sym
          define_method nm do |*args|
            b = nil
            b = Proc.new { yield } if block_given?
            isolation_context.send_message(nm, mem.return_type, *args, &b)
          end unless nm == :to_string
        end

      end

      klass
    end

  end

  # An +Isolator+ for CLR interfaces.
  # this implements all the methods that are defined on the interface.
  class ClrInterfaceIsolator < Isolator

    # Implementation of the template method that creates
    # an isolator for an interface defined in a CLR language.
    def initialize(context)
      super
      sklass = context.subject
      @descriptor = ClrInterfaceDescriptor.new sklass
      build_isolation sklass
    end

    # initializes the messaging strategy for the isolator
    def initialize_messenger
      @context.messenger = ClrInterfaceMessenger.new @context.expectations
    end

    # builds the actual +isolator+ for the CLR interface
    def create_isolation_for(subj)
      proxy_members = @descriptor.instance_members

      klass = Object.const_set(class_name(subj), Class.new)
      klass.class_eval do

        include subj
        include Interception

        proxy_members.each do |mem|
          nm = mem.name.to_s.to_sym
          define_method nm do |*args|
            b = nil
            b = Proc.new { yield } if block_given?
            isolation_context.send_message(nm, mem.return_type, *args, &b)
          end
        end

      end

      klass
    end
  end

end