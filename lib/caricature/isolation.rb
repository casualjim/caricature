require File.dirname(__FILE__) + '/isolator'
require File.dirname(__FILE__) + '/method_call_recorder'
require File.dirname(__FILE__) + '/expectation'
require File.dirname(__FILE__) + '/verification'

module Caricature

  IsolationContext = Struct.new(:subject, :recorder, :expectations)

  # Instead of using confusing terms like Mocking and Stubbing which is basically the same. Caricature tries
  # to unify those concepts by using a term of *Isolation*.
  # When you're testing you typically want to be in control of what you're testing. To do that you isolate
  # dependencies and possibly define return values for methods on them.
  # At a later stage you might be interested in which method was called, maybe even with which parameters
  # or you might be interested in the amount of times it has been called.
  class Isolation

    class << self

      # Creates an isolation object complete with proxy and method call recorder
      # It works out which proxy it needs to create and provide and initializes the
      # method call recorder
      def for(subject, recorder = MethodCallRecorder.new, expectations = Expectations.new)
        clr_t = subject.is_clr_type?

        isolation_strategy = clr_t ? get_clr_isolation_strategy(subject) : RubyIsolator
        isolation = isolation_strategy.isolate(subject, recorder, expectations)

        isolation
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

  # +Mock+ is a synonym for +Isolation+ so you can still use it if you're that way inclined
  Mock = Isolation unless defined? Mock

  # +Stub+ is a synonym for +Isolation+ so you can still use it if you're that way inclined
  Stub = Isolation unless defined? Stub

end