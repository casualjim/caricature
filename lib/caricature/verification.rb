module Caricature

  # Describes a verification of a method call.
  # This corresponds kind of to an assertion
  class Verification

    # Initializes a new instance of a +Verification+
    def initialize(method_name, recorder, mode=:instance)
      @method_name, @args, @any_args, @recorder, @mode = method_name, [], true, recorder, mode
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

    # allow any arguments ignore the argument constraint
    def allow_any_arguments
      @any_args = true
      self
    end

    # figure out if this argument variation matches the provided args.
    def matches?(method_name, *args)
      @method_name == method_name and any_args? or @args == args
    end

    # indicate that this method verification is successful
    def successful?
      a = any_args? ? [:any] : @args
      @recorder.was_called?(@method_name, @mode, *a)
    end

  end

end