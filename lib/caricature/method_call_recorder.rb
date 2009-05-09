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
   
    def ==(other)
      other.args == args
    end
  end

  class MethodCallRecording
    
    attr_accessor :method_name, :count, :args, :block

    def initialize(method_name, count=0)
      @method_name = method_name
      @count = count
      @variations = []
    end

    def args
      @variations
    end

    def has_argument_variations?
      @variations.size > 1
    end

    def add_argument_variation(args, block)
      variation = find_argument_variations args
      @variations << ArgumentRecording.new(args, @variations.size+1, block) if variation == []
    end

    def find_argument_variations(args)
      @variations.select { |ar| ar.args == args }
    end
  end

  class MethodCallRecorder

    attr_reader :method_calls

    def initialize
      @method_calls = {}
    end

    def record_call(method_name, *args, &block)
      mn_sym = method_name.to_s.to_sym
      method_calls[mn_sym] ||= MethodCallRecording.new method_name
      mc = method_calls[mn_sym]
      mc.count += 1
      mc.add_argument_variation args, block 
    end

    def was_called?(method_name)
      !method_calls[method_name.to_s.to_sym].nil?
    end

    def [](method_name)
      method_calls[method_name.to_s.to_sym]
    end

    def size
      @method_calls.size
    end
  end


end