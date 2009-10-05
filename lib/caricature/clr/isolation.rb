module Caricature

  class Isolation

    attr_reader :events

    def events
      @events ||= {}
    end

    def add_event_subscription(event_name, handler)
      (events[event_name_for(event_name)] ||=[]) << handler
    end

    def remove_event_subscription(event_name, handler)
      (events[event_name_for(event_name)] ||=[]).delete(handler)
    end

    class << self

      # Creates an isolation object complete with proxy and method call recorder
      # It works out which isolation it needs to create and provide and initializes the
      # method call recorder
      def for(subject, recorder = MethodCallRecorder.new, expectations = Expectations.new)
        context = IsolatorContext.new subject, recorder, expectations
        isolation_strategy = subject.clr_type? ? get_clr_isolation_strategy(subject) : RubyIsolator

        isolator = isolation_strategy.for context
        isolation = new(isolator, context)
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
    
    protected
    
      def internal_create_override(method_name, mode=:instance, &block)
        builder = ExpectationBuilder.new method_name
        block.call builder unless block.nil?
        exp = builder.build           
        expectations.add_expectation exp, mode
        exp
      end

    private

    def event_name_for(method_name)
      method_name.gsub(/^(add|remove)_/, '').underscore.to_sym
    end

  end

end