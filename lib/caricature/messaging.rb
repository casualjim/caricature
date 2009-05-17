module Caricature

  # A base class to encapsulate method invocation
  class Messenger

    # the real instance of the isolated subject
    # used to forward calls in partial mocks
    attr_reader :instance

    # the expecations that have been set for the isolation
    attr_reader :expectations

    def initialize(context, instance=nil)
      @instance, @expectations = instance, context.expectations
    end

    def deliver(method_name, return_type, *args, &b)
      raise NotImplementedError
    end
    

  end

  class RubyMessenger < Messenger


    def deliver(method_name, return_type, *args, &b)
      exp = expectations.find(method_name, args)
      if exp
        res = instance.__send__(method_name, *args, &b) if exp.super_before?
        res = exp.execute *args
        res = instance.__send__(method_name, *args, &b) if !exp.super_before? and exp.call_super?
        res
      else
        nil
      end
    end

  end

  class ClrClassMessenger < Messenger

    def deliver(method_name, return_type, *args, &b)
      exp = expectations.find(method_name, args)
      if exp
        res = instance.__send__(method_name, *args, &b) if exp.super_before?
        res = exp.execute *args
        res = instance.__send__(method_name, *args, &b) if !exp.super_before? and exp.call_super?
        res
      else
        rt = nil
        is_value_type = return_type && return_type != System::Void.to_clr_type && return_type.is_value_type
        rt = System::Activator.create_instance(return_type) if is_value_type
        rt
      end
    end

  end

  class ClrInterfaceMessenger < Messenger

    def deliver(method_name, return_type, *args, &b)
      exp = expectations.find(method_name, args)
      if exp
        exp.execute *args               
      else
        rt = nil
        rt = System::Activator.create_instance(return_type) if return_type && return_type != System::Void.to_clr_type && return_type.is_value_type
        rt
      end
    end

  end

end