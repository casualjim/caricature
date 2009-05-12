load File.dirname(__FILE__) + '/proxy.rb'
load File.dirname(__FILE__) + '/method_call_recorder.rb'
load File.dirname(__FILE__) + '/expectation.rb'
load File.dirname(__FILE__) + '/verification.rb'

module Caricature

  module Interception

    # Replaces the call to the proxy with the one you create with this method.
    # You can specify more specific criteria in the block to configure the expectation.
    #
    # Example:
    #
    # an_isolation.when_told_to(:a_method) do |method_call|
    #   method_call.with(3, "a").return(5)
    # end
    #
    # You will most likely use this method when you want your stubs to return something else than +nil+
    # when they get called during the run of the test they are defined in.
    def when_told_to(method_name, &block)
      @___expectations___ ||= Expectations.new
      builder = ExpectationBuilder.new method_name, @___recorder___
      block.call builder unless block.nil?
      exp = builder.build
      @___expectations___ << exp
      exp
    end

    # Verifies whether the specified method has been called
    # You can specify constraints in the block
    #
    # The most complex configuration you can make currently is one that is constrained by arguments.
    # This is most likely to be extended in the future to allow for more complex verifications.
    #
    # Example:
    #
    # an_isolation.was_told_to?(:a_method) do |method_call|
    #   method_call.with(3, "a")
    # end.should.be.true?
    #
    # You will probably be using this method only when you're interested in whether a method has been called
    # during the course of the test you're running.
    def was_told_to?(method_name, &block)
      verification = Verification.new(method_name, @___recorder___)
      block.call verification unless block.nil?
      verification
    end

  end

  # Instead of using confusing terms like Mocking and Stubbing which is basically the same. Caricature tries
  # to unify those concepts by using a term of *Isolation*.
  # When you're testing you typically want to be in control of what you're testing. To do that you isolate
  # dependencies and possibly define return values for methods on them.
  # At a later stage you might be interested in which method was called, maybe even with which parameters
  # or you might be interested in the amount of times it has been called.
  class Isolation

    # remove all methods from this isolation so that we are sure to forward everything to the proxy or expectations
    instance_methods.each do |name|
      undef_method name unless name =~ /^__$|^instance_eval$/
    end

    include Interception

    # an accessor for the proxy directly. You probably don't want to use this object directly
    def object
      @proxy
    end

    # initializes a new isolation object with the specified +proxy+ and +recorder+
    def initialize(proxy, recorder, expectations)
      @proxy, @___recorder___ = proxy, recorder
      @___expectations___ = Expectations.new
    end



    # used as a method dispatcher
    # figures out where to get the result of the method call from.
    def method_missing(m, *a, &b)
      exp = @___expectations___.find(nm, args)
      if exp
        sup = @proxy.instance_variable_get("@___super___")
        sup.__send__(nm, *args, &b) if exp.super_before?
        exp.execute
        sup.__send__(nm, *args, &b) if !exp.super_before? and exp.has_super?
      else
        @proxy.__send__(m, *a, &b)
      end
      
    end
    
    class << self

      # Creates an isolation object complete with proxy and method call recorder
      # It works out which proxy it needs to create and provide and initializes the
      # method call recorder
      def for(subject)
        recorder = MethodCallRecorder.new
        expectations = Expectations.new

        clr_t = subject.is_clr_type?
        proxy_class = clr_t ? RecordingClrProxy : RecordingProxy
        proxy = proxy_class.for(subject, recorder, expectations)

        isolation = new(proxy, recorder, expectations)
        clr_t ? isolation.object : isolation 
      end

    end
  end

  # +Mock+ is a synonym for +Isolation+ so you can still use it if you're that way inclined
  Mock = Isolation

  # +Stub+ is a synonym for +Isolation+ so you can still use it if you're that way inclined
  Stub = Isolation

end