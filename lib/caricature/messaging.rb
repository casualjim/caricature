module Caricature

  # A base class to encapsulate method invocation
  class Messenger

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
      raise NotImplementedError
    end

  end

  # Encapsulates sending messages to Ruby isolations
  class RubyMessenger < Messenger

    # deliver the message to the receiving isolation
    def deliver(method_name, return_type, *args, &b)
      exp = expectations.find(method_name, *args)
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

  # Encapsulates sending messages to CLR class or instance isolations
  class ClrClassMessenger < Messenger

    # deliver the message to the receiving isolation
    def deliver(method_name, return_type, *args, &b)
      exp = expectations.find(method_name, *args)
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

  # Encapsulates sending messages to CLR interface isolations
  class ClrInterfaceMessenger < Messenger

    # deliver the message to the receiving isolation
    def deliver(method_name, return_type, *args, &b)
      exp = expectations.find(method_name, *args)
      if exp
        res = exp.execute *args
        res
      else
        rt = nil
        rt = System::Activator.create_instance(return_type) if return_type && return_type != System::Void.to_clr_type && return_type.is_value_type
        rt
      end
    end

  end

end