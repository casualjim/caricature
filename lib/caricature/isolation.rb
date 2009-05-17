require File.dirname(__FILE__) + '/isolator'
require File.dirname(__FILE__) + '/method_call_recorder'
require File.dirname(__FILE__) + '/expectation'
require File.dirname(__FILE__) + '/verification'

# Caricature - Bringing simple mocking to the DLR
# ===============================================
#
# This project aims to make interop between IronRuby objects and .NET objects easier.
# The idea is that it integrates nicely with bacon and later rspec and that it transparently lets you mock ironruby ojbects
# as well as CLR objects/interfaces.
# Caricature handles interfaces, interface inheritance, CLR objects, CLR object instances, Ruby classes and instances of Ruby classes.
#
# From the start I wanted to do away with names like mock, stub, record, replay, verify etc.
# Instead I took the advice from Roy Osherhove and went with a name of Isolation for creating a mock.
#
# An Isolation will create what in Rhino.Mocks would be called a DynamicMock (but can be a partial too) :)
# In Moq it would be the Loose mocking strategy.
#
# The naming of the methods for creating mocks is the one that JP Boodhoo proposed WhenToldTo and WasToldTo.
# To specify a stub/expectation on an isolation you have one and only one way of doing that with the method called when_receiving.
# Then only if you're interested in asserting if a method has been called you can use the did_receive? method for this.
#
#
#     isolation = Isolation.for(Ninja)
#     isolation.when_receiving(:attack) do |exp|
#       exp.with(:shuriken)
#       exp.return(3)
#     end
#
#     Battle.new(mock)
#     battle.combat
#
#     isolation.did_receive?(:attack).should.be.true?
#
#
# It may be very important to note that when you're going to be isolating CLR classes to be used in other CLR classes
# you still need to obide by the CLR rules. That means if you want to redefine a method you'll need to make sure it's
# marked as virtual. Static types are still governed by static type rules.  I'm working on a solution around those
# problems but for the time being this is how it has to be.
module Caricature

  IsolatorContext = Struct.new(:subject, :recorder, :expectations, :messenger)

  # Instead of using confusing terms like Mocking and Stubbing which is basically the same. Caricature tries
  # to unify those concepts by using a term of *Isolation*.
  # When you're testing you typically want to be in control of what you're testing. To do that you isolate
  # dependencies and possibly define return values for methods on them.
  # At a later stage you might be interested in which method was called, maybe even with which parameters
  # or you might be interested in the amount of times it has been called.
  class Isolation

    # the real instance of the isolated subject
    # used to forward calls in partial mocks
    attr_reader :instance

    # the method call recorder
    attr_reader :recorder

    # the expectations on the object
    attr_reader :expectations

    def initialize(isolator, context)
      @recorder = context.recorder
      @messenger = context.messenger
      @expectations = context.expectations
      isolator.first.instance_variable_set("@___context___", self)
    end

    def send_message(method_name, return_type, *args, &b)
      recorder.record_call method_name, *args, &b
      @messenger.deliver(method_name, return_type, *args, &b)
    end

    class << self

      # Creates an isolation object complete with proxy and method call recorder
      # It works out which isolation it needs to create and provide and initializes the
      # method call recorder
      def for(subject, recorder = MethodCallRecorder.new, expectations = Expectations.new)
        context = IsolatorContext.new subject, recorder, expectations
        isolation_strategy = subject.is_clr_type? ? get_clr_isolation_strategy(subject) : RubyIsolator

        isolator = isolation_strategy.isolate(context)
        isolation = new(isolator, context)
        isolator.first
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