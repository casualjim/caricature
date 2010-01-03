module Caricature
  
  

  class Isolation # :nodoc:

    # the event subscriptions collected at runtime
    attr_reader :events
    
    # the event subscriptions collected at runtime
    def events
      @events ||= {}
    end

    # adds an event subscription
    def add_event_subscription(event_name, mode, handler)
      events[mode] ||= {}
      nm = event_name_for(event_name)
      events[mode][nm] ||= []
      events[mode][nm] << handler
    end

    # removes an event subscription
    def remove_event_subscription(event_name, mode, handler)
      ((events[mode] ||= {})[event_name_for(event_name)] ||=[]).delete(handler)
    end
    
    # def add_event_expectation(name, mode, *args, &handler)
    # end
    
    def internal_create_override(method_name, mode=:instance, &block)
      builder = ExpectationBuilder.new method_name
      block.call builder unless block.nil?
      exp = builder.build
      exp.events = events[mode]         
      expectations.add_expectation exp, mode
      exp
    end
    
    def verify_event_raise(event_name, mode= :instance, &block)
      verification = EventVerification.new(event_name, recorder, mode)
      block.call verification unless block.nil?
      verification
    end

    class << self

      # Creates an isolation object complete with proxy and method call recorder
      # It works out which isolation it needs to create and provide and initializes the
      # method call recorder
      def for(subject, recorder = MethodCallRecorder.new, expectations = Expectations.new)
        context = IsolatorContext.new subject, recorder, expectations
        isolation_strategy = subject.clr_type? ? get_clr_isolation_strategy(subject) : RubyIsolator

        isolator = isolation_strategy.for context
        new(isolator, context)
        isolator.isolation
      end

      private

        # decides which startegy to use for mocking a CLR object.
        # When the provided subject is an interface it will return a +ClrInterfaceIsolator+
        # otherwise it will return a +ClrIsolator+
        def get_clr_isolation_strategy(subject)
          return ClrInterfaceIsolator if subject.respond_to? :class_eval and !subject.respond_to? :new
          ClrIsolator
        end
    end 

    private

    def event_name_for(method_name) #:nodoc:
      method_name.gsub(/^(add|remove)_/, '').underscore.to_sym
    end

  end

end