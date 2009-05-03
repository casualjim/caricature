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

  MethodCall = Struct.new :method_name, :args, :block

  class SimpleProxy

    instance_methods.each do |name|
      undef_method name unless name =~ /^__|^instance_eval$/
    end
    

    attr_reader :subject, :method_calls

    def initialize(obj)
      @subject = create_proxy(obj)
      @method_calls = []
    end

    def proxy_name
      "#{class_name(@subject)}Proxy"
    end
    
    def method_missing(method, *args, &block)
      @method_calls << MethodCall.new(method, args, &block)
      @subject.send(method, *args, &block)
    end

    protected

    def create_proxy(obj)
      obj
    end

    def class_name(subj)
      nm = subj.respond_to?(:class_eval) ? subj.demodulize : subj.class.demodulize
      @class_name ||= "#{nm}#{System::Guid.new_guid.to_string('n')}"
      @class_name
    end

  end

  class ClrProxy < SimpleProxy

    protected

    def create_proxy(subj)
      return subj unless subj.respond_to?(:class_eval)
      return create_interface_proxy_for(subj) unless subj.respond_to?(:new)
      subj.new
    end

    def create_interface_proxy_for(subj)
      clr_type = subj.to_clr_type

      proxy_members = clr_type.get_methods.collect { |mi| mi.name.underscore }
      proxy_members += clr_type.get_properties.collect { |pi| pi.name.underscore }

      klass = Object.const_set class_name(subj), Class.new do
        include subj

        proxy_members.each { |mem| define_method mem.to_s.to_sym }
      end

      klass.new
    end
    
  end
  
end