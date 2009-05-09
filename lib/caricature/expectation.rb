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

module Caricature

  class Expectations

    def initialize
      @inner = []
    end

    def <<(expectation)
      @inner << expectation
    end

    def find(method_name, *args)
      candidates = @inner.select { |exp| exp.method_name == method_name }
      return candidates.first if args.first == :any
      second_pass = candidates.select {|exp| exp.args == args }
      second_pass.first
    end

  end

  class Expectation

    attr_reader  :method_name, :args, :error_args, :return_value, :super

    def initialize(method_name, args, error_args, return_value, super_mode, record)
      @method_name, @args, @error_args, @return_value, @super, @record =
              method_name, args, error_args, return_value, super_mode, record
    end

    def has_error_args?
      !@error_args.nil?
    end

    def has_return_value?
      !@return_value.nil?
    end

    def has_super?
      !@super.nil?
    end

    def execute
      @recorder.record_call method_name, args

    end
  end

  class ExpectationBuilder
    
    def initialize(method_name, recorder)
      @method_name, @recorder, @return_value, @super, @block, @error_args, @args, @any_args = 
              method_name, recorder, nil, nil, nil, nil, [], true
    end

    def with *args
      @any_args = false unless args.first == :any
      @args = args
      self
    end

    def return(value=nil)
      @return_value = value
      @return_value ||= yield if block_given?
      self
    end

    def raise(*args)
      @error_args = args
      self
    end

    def super_before
      @super = :before
    end

    def super_after
      @super = :after
    end

    def build
      Expectation.new @method_name, @args, @error_args, @return_value, @super, @recorder      
    end

  end

end