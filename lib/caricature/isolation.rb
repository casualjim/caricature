load File.dirname(__FILE__) + '/isolator.rb'
load File.dirname(__FILE__) + '/method_call_recorder.rb'
load File.dirname(__FILE__) + '/expectation.rb'
load File.dirname(__FILE__) + '/verification.rb'

module Caricature

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
        proxy_class = clr_t ? ClrIsolator : RubyIsolator
        proxy = proxy_class.for(subject, recorder, expectations)

        proxy
      end

    end
  end

  # +Mock+ is a synonym for +Isolation+ so you can still use it if you're that way inclined
  Mock = Isolation unless defined? Mock

  # +Stub+ is a synonym for +Isolation+ so you can still use it if you're that way inclined
  Stub = Isolation unless defined? Stub

end