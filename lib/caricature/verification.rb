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

  # Describes a verification of a method call.
  # This corresponds kind of to an assertion
  class Verification

    def initialize(method_name, recorder)
      @method_name, @args, @any_args, @recorder = method_name, [], true, recorder
    end

    # indicates whether this verification can be for any arguments
    def any_args?
      @any_args
    end

    # constrain this verification to the provided arguments
    def with(*args)
      @any_args = false unless args.first == :any
      @args = args
      self
    end

    # allow any arguments ignore the argument constraint
    def allow_any_arguments
      @any_args = true
      self
    end

    # figure out if this argument variation matches the provided args.
    def matches?(method_name, *args)
      @method_name == method_name and any_args? or @args == args
    end

    # indicate that this method verification is successful
    def successful?
      a = any_args? ? [:any] : @args
      @recorder.was_called?(@method_name, *a)
    end

  end

end