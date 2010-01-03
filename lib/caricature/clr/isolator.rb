module Caricature

  # Groups the methods for interception together
  # this is a mix-in for the created isolations for classes
  module Interception

    # the class methods of this intercepting object
    module ClassMethods

      # Raises an event on the isolation
      # You can specify the arguments in the block or as parameters
      #
      # Example
      #
      #     an_isolation.class.raise_event :on_property_changed do |raiser|
      #       raiser.with an_isolation, System::EventArgs.empty
      #     end
      #
      # is equivalent to:
      #
      #     an_isolation.class.raise_event :on_property_changed, an_isolation, System::EventArgs.empty
      #
      # or
      #
      #     an_isolation.class.raise_event(:on_property_changed).with(an_isolation, System::EventArgs.empty)
      #
      # You will most likely use this method when you want to verify logic in an event handler
      # You will most likely use this method when you want to verify logic in an event handler
      def raise_event(event_name, *args, &block)
        isolation_context.add_event_expectation event_name, :class, *args, &block
      end
      
      # Verifies whether the specified event was raised
      #
      # You will probably be using this method only when you're interested in whether an event has been raised
      # during the course of the test you're running.
      def did_raise_event?(event_name, &b)
        isolation_context.verify_event_raise event_name, :class, &b
      end

    end

    # Raises an event on the isolation
    # You can specify the arguments in the block or as parameters
    #
    # Example
    #
    #     an_isolation.raise_event :on_property_changed do |raiser|
    #       raiser.with an_isolation, System::EventArgs.empty
    #     end
    #
    # is equivalent to:
    #
    #     an_isolation.raise_event :on_property_changed, an_isolation, System::EventArgs.empty
    #
    # or
    #
    #     an_isolation.raise_event(:on_property_changed).with(an_isolation, System::EventArgs.empty)
    #
    # You will most likely use this method when you want to verify logic in an event handler
    def raise_event(event_name, *args, &block)
      isolation_context.add_event_expectation event_name, :instance, *args, &block
    end

    # Raises an event on the isolation
    # You can specify the arguments in the block or as parameters
    #
    # Example
    #
    #     an_isolation.raise_class_event :on_property_changed do |raiser|
    #       raiser.with an_isolation, System::EventArgs.empty
    #     end
    #
    # is equivalent to:
    #
    #     an_isolation.raise_class_event :on_property_changed, an_isolation, System::EventArgs.empty
    #
    # or
    #
    #     an_isolation.raise_class_event(:on_property_changed).with(an_isolation, System::EventArgs.empty)
    #
    # You will most likely use this method when you want to verify logic in an event handler
    def raise_class_event(event_name, *args, &block)
      self.class.raise_event event_name, *args, &block
    end

    # Verifies whether the specified event was raised
    #
    # You will probably be using this method only when you're interested in whether an event has been raised
    # during the course of the test you're running.
    def did_raise_event?(event_name, &b)
      isolation_context.verify_event_raise event_name, :instance, &b
    end
    
    # Verifies whether the specified event was raised
    #
    # You will probably be using this method only when you're interested in whether an event has been raised
    # during the course of the test you're running.
    def did_raise_class_event?(event_name, &b)
      self.class.did_raise_event? event_name, &b
    end

  end

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
      instance ||= sklass.new unless sklass.to_clr_type.is_abstract
      build_isolation sklass, instance
    end

    # initializes the messaging strategy for the isolator
    def initialize_messenger
      @context.messenger = ClrClassMessenger.new @context.expectations, @subject
    end

    # builds the Isolator class for the specified subject
    def create_isolation_for(subj)
      members = @descriptor.instance_members
      class_members = @descriptor.class_members
      events = @descriptor.events
      class_events = @descriptor.class_events

      klass = Object.const_set(class_name(subj), Class.new(subj))
      klass.class_eval do

        include Interception

        # access to the proxied subject
        def ___super___
          isolation_context.instance
        end

        def initialize(*args)
          self
        end

        members.each do |mem|
          nm = mem.name.to_s.to_sym
          define_method nm do |*args|
            b = nil
            b = Proc.new { yield } if block_given?
            isolation_context.send_message(nm, mem.return_type, *args, &b)
          end unless nm == :to_string
        end

        class_members.each do |mn|
          mn = mn.name.to_s.to_sym
          define_cmethod mn do |*args|
            b = nil
            b = Proc.new { yield } if block_given?
            isolation_context.send_class_message(mn, nil, *args, &b)
          end
        end
        
       evts = (events + class_events).collect do |evt|
         %w(add remove).inject("") do |res, nm|
           res << <<-end_event_definition
           
def #{"self." unless evt.instance_member?}#{nm}_#{evt.event_name}(block)
  self.isolation_context.#{nm}_event_subscription('#{evt.event_name}', :#{evt.instance_member? ? "instance" : "class"}, block)
end
 
           end_event_definition
         end

        end.join("\n")

        klass.class_eval evts
        
        #puts evts

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
      events = @descriptor.events

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

      evts = events.collect do |evt|
       %w(add remove).inject("") do |res, nm|
         res << <<-end_event_definition

def #{"self." unless evt.instance_member?}#{nm}_#{evt.event_name}(block)
  isolation_context.#{nm}_event_subscription('#{evt.event_name}', :#{evt.instance_member? ? "instance" : "class"}, block)
end

         end_event_definition
       end
      end.join("\n")
      klass.class_eval evts

      klass
    end
  end

end