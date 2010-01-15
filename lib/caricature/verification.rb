module Caricature

  # Describes a verification of a method call.
  # This corresponds kind of to an assertion
  class Verification

    # Initializes a new instance of a +Verification+
    def initialize(method_name, recorder, mode=:instance)
      @method_name, @args, @any_args, @recorder, @mode, @block_args = method_name, [], true, recorder, mode, nil
      init_plugin
    end
    
    def init_plugin
      
    end

    # indicates whether this verification can be for any arguments
    def any_args?
      @any_args
    end

    # constrain this verification to the provided arguments
    def with(*args)
      @any_args = args.first.is_a?(Symbol) and args.first == :any
      @args = args 
     # @callback = b if b
      self
    end

    def with_block_args(*args)
      @block_args = args
    end

    # allow any arguments ignore the argument constraint
    def allow_any_arguments
      @any_args = true
      self
    end

    # figure out if this argument variation matches the provided args.
    def matches?(method_name, *args)
      @method_name == method_name and any_args? or @args == args
    end

    def error
      @recorder.error
    end

    # indicate that this method verification is successful
    def successful?
      a = any_args? ? [:any] : @args
      begin
        @recorder.was_called?(@method_name, @block_args, @mode, *a)
      rescue ArgumentError
        false
      end
    end

  end

end