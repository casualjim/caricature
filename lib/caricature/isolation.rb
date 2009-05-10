# Caricature -- A simple mocking framework for IronRuby
#
# Copyright (c) 2009, Caricature Team
# http://github.com/casualjim/caricature
# All rights reserved.
#
# Redistribution and use in source and binary forms,
# with or without modification, are permitted provided
# that the following conditions are met:
#
#    * Redistributions of source code must retain the
#    above copyright notice, this list of conditions and
#    the following disclaimer.
#
#    * Redistributions in binary form must reproduce
#    the above copyright notice, this list of conditions
#    and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
#    * Neither the name of the Caricature Team nor the
#    names of its contributors may be used to endorse
#    or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
# [This is the BSD license, see
#  http://www.opensource.org/licenses/bsd-license.php]

require File.dirname(__FILE__) + '/proxy'
require File.dirname(__FILE__) + '/method_call_recorder'
require File.dirname(__FILE__) + '/expectation'
require File.dirname(__FILE__) + '/verification'

module Caricature

  # Instead of using confusing terms like Mocking and Stubbing which is basically the same. Caricature tries
  # to unify those concepts by using a term of *Isolation*.
  # When you're testing you typically want to be in control of what you're testing. To do that you isolate
  # dependencies and possibly define return values for methods on them.
  # At a later stage you might be interested in which method was called, maybe even with which parameters
  # or you might be interested in the amount of times it has been called.
  class Isolation

    # remove all methods from this isolation so that we are sure to forward everything to the proxy or expectations
    instance_methods.each do |name|
      undef_method name unless name =~ /^__$/
    end

    # an accessor for the proxy directly. You probably don't want to use this object directly
    attr_reader :proxy

    def initialize(proxy, recorder)
      @proxy, @recorder = proxy, recorder
      @expectations = Expectations.new
    end

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
      builder = ExpectationBuilder.new method_name, @recorder
      block.call builder unless block.nil?
      exp = builder.build
      @expectations << exp
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
      verification = Verification.new(method_name, @recorder)
      block.call verification unless block.nil?
      verification.successful?
    end

    # used as a method dispatcher
    # figures out where to get the result of the method call from.
    def method_missing(m, *a, &b)
      exp = @expectations.find(m, a)
      if exp
        @proxy.__send__(m, *a, &b) if exp.super_before?
        exp.execute
        @proxy.__send__(m, *a, &b) if !exp.super_before? and exp.has_super?
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
        proxy = subject.is_clr_type? ? RecordingClrProxy.new(subject, recorder) : RecordingProxy.new(subject, recorder)

        new(proxy, recorder)
      end

    end
  end

  # +Mock+ is a synonym for +Isolation+ so you can still use it if you're that way inclined
  Mock = Isolation

  # +Stub+ is a synonym for +Isolation+ so you can still use it if you're that way inclined
  Stub = Isolation

end