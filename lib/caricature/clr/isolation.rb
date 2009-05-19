module Caricature

  class Isolation

    class << self

      # Creates an isolation object complete with proxy and method call recorder
      # It works out which isolation it needs to create and provide and initializes the
      # method call recorder
      def for(subject, recorder = MethodCallRecorder.new, expectations = Expectations.new)
        context = IsolatorContext.new subject, recorder, expectations
        isolation_strategy = subject.is_clr_type? ? get_clr_isolation_strategy(subject) : RubyIsolator

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
    

  end

end