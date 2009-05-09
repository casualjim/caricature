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

require 'caricature/proxy'
require 'caricature/method_call_recorder'
require 'caricature/expectation'
require 'caricature/verification'

module Caricature

  class Isolator

    attr_reader :proxy, :recorder

    def initialize(proxy, recorder)
      @proxy, @recorder = proxy, recorder
      @expectations = Expectations.new
    end

    def when_told_to(method_name, &block)
      builder = ExpectationBuilder.new method_name, @recorder
      block.call builder unless block.nil?
      exp = builder.build
      @expectations << exp
      exp
    end

    def was_told_to?(method_name, &block)
      verification = Verification.new(method_name, @recorder)
      block.call verification unless block.nil?
      verification.successful?
    end

    def method_missing(m, *a, &b)
      exp = @expectations.find(m, a)
      if exp
        proxy.__send__(m, *a, &b) if exp.super_before?
        exp.execute
        proxy.__send__(m, *a, &b) unless exp.super_before?
      else
        proxy.__send__(m, *a, &b)
      end
    end
    
    class << self

      def for(subject)
        recorder = MethodCallRecorder.new
        proxy = subject.is_clr_type? ? RecordingClrProxy.new(subject, recorder) : RecordingProxy.new(subject, recorder)

        new(proxy, recorder)
      end

    end
  end

  Mock = Isolator
  Stub = Isolator

end