module Caricature

  # A base class to encapsulate method invocation
  class Messenger

    # contains the recorder for recording method calls
    attr_accessor :recorder

    # the real instance of the isolated subject
    # used to forward calls in partial mocks
    attr_reader :instance

    # the expecations that have been set for the isolation
    attr_reader :expectations

    # creates a new instance of this messaging strategy
    def initialize(expectations, instance=nil)
      @instance, @expectations = instance, expectations
    end

    # deliver the message to the receiving isolation
    def deliver(method_name, return_type, *args, &b)
      
      internal_deliver(:instance, method_name, return_type, *args, &b)
    end

    # deliver the message to class of the receiving isolation
    def deliver_to_class(method_name, return_type, *args, &b)
      internal_deliver(:class, method_name, return_type, *args, &b)
    end

    protected

      # template method for looking up the expectation and/or returning a value
      def internal_deliver(mode, method_name, return_type, *args, &b)
        raise NotImplementedError.new("Override in an implementing class")
      end
    
    private
    def record_call(method_name, mode, expectation, *args, &b)
      recorder.record_call method_name, mode, expectation, *args, &b if recorder
    end

  end

  # Encapsulates sending messages to Ruby isolations
  class RubyMessenger < Messenger

    protected

      # implementation of the template method for looking up the expectation and/or returning a value
      def internal_deliver(mode, method_name, return_type, *args, &b)   
        exp = expectations.find(method_name, mode, *args)
        bl = record_call(method_name, mode, exp, *args, &b)
        if exp     
          block = exp.block || b
          res = instance.__send__(method_name, *args, &block) if exp.super_before?
          res = exp.execute *args, &bl
          res = instance.__send__(method_name, *args, &block) if !exp.super_before? and exp.call_super?
          res
        else
          nil
        end
      end

  end

end