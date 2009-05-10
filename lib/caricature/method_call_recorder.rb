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

  # A recording of an argument variation.
  class ArgumentRecording

    # contains the arguments of the recorded parameters
    attr_accessor :args

    # contains the block for the recorded parameters
    attr_accessor :block

    # the number of the call that has the following parameters
    attr_accessor :call_number

    def initialize(args=[], call_number=1, block=nil)
      @args = args
      @block = block
      @call_number = call_number
    end

    # compares one argument variation to another.
    # Also takes an array as an argument
    def ==(other)
      other = self.class.new(other) if other.respond_to?(:each)
      return true if other.args.first == :any
      other.args == args
    end
  end

  # A recording that represents a method call
  # it contains argument variations that can be matched too
  class MethodCallRecording

    # gets or sets the method name
    attr_accessor :method_name

    # gets or sets the amount of times the method was called
    attr_accessor :count

    # gets or sets the arguments for this method call
    attr_accessor :args

    # gets or sets the block for this method call
    attr_accessor :block

    def initialize(method_name, count=0)
      @method_name = method_name
      @count = count
      @variations = []
    end

    # add args
    def args
      @variations
    end

    # indicates if it has an argument variation
    def has_argument_variations?
      @variations.size > 1
    end

    # add an argument variation
    def add_argument_variation(args, block)
      variation = find_argument_variations args
      @variations << ArgumentRecording.new(args, @variations.size+1, block) if variation == []
    end

    # finds an argument variation that matches the provided +args+
    def find_argument_variations(args)
      return @variations if args.first == :any
      @variations.select { |ar| ar.args == args }
    end
  end

  # The recorder that will collect method calls and provides an interface for finding those recordings
  class MethodCallRecorder

    # gets the collection of method calls. This is a hash with the method name as key
    attr_reader :method_calls

    def initialize
      @method_calls = {}
    end

    # records a method call or increments the count of how many times this method was called.
    def record_call(method_name, *args, &block)
      mn_sym = method_name.to_s.to_sym
      method_calls[mn_sym] ||= MethodCallRecording.new method_name
      mc = method_calls[mn_sym]
      mc.count += 1
      mc.add_argument_variation args, block 
    end

    # returns whether the method was actually called with the specified constraints
    def was_called?(method_name, *args)
      mc = method_calls[method_name.to_s.to_sym]
      if mc
        return mc.find_argument_variations(args).first == args        
      else
        return !!mc
      end
    end

    # indexer that gives you access to the recorded method by method name
    def [](method_name)
      method_calls[method_name.to_s.to_sym]
    end

    # returns the number of different methods that has been recorderd
    def size
      @method_calls.size
    end
  end


end