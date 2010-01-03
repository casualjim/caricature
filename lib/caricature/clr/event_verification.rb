module Caricature

  # Describes a verification of a method call.
  # This corresponds kind of to an assertion
  class EventVerification 

    # Initializes a new instance of a +Verification+
    def initialize(event_name, recorder, mode=:instance)
      @event_name, @args, @any_args, @recorder, @mode = event_name, [], true, recorder, mode
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

    # allow any arguments ignore the argument constraint
    def allow_any_arguments
      @any_args = true
      self
    end

    # figure out if this argument variation matches the provided args.
    def matches?(event_name, *args)
      @event_name == event_name and (any_args? or @args == args)
    end

    def error
      @recorder.event_error
    end

    # indicate that this method verification is successful
    def successful?
      a = any_args? ? [:any] : @args
      begin
        @recorder.event_raised?(@event_name, @mode, *a)
      rescue ArgumentError
        false
      end
    end

  end

end