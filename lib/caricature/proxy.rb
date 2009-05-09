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

  class RecordingProxy

    instance_methods.each do |name|
      undef_method name unless name =~ /^__|^instance_eval$/
    end

    def initialize(subj, recorder)
      @subject = ___create_proxy___(subj)
      @recorder = recorder
    end

    def is_clr_proxy?
      false
    end

    def ___proxy_name___
      "#{___class_name___(@subject)}Proxy"
    end

    def method_missing(method_name, *args, &block)
      puts method_name
      @recorder.record_call method_name, *args, &block
      block.nil? ? @subject.send(method_name, *args) : @subject.send(method_name, *args, &block)
    end
    
    def ___subject___
      @subject
    end

    def inspect
      ___proxy_name___
    end

    protected

    def ___create_proxy___(subj)
      return subj unless subj.respond_to?(:class_eval)
      subj.new
    end

    def ___class_name___(subj)
      nm = subj.respond_to?(:class_eval) ? subj.demodulize : subj.class.demodulize
      @class_name ||= "#{nm}#{System::Guid.new_guid.to_string('n')}"
      @class_name
    end

  end

  class RecordingClrProxy < RecordingProxy

    def is_clr_proxy?
      true
    end

    protected

    def ___create_proxy___(subj)
      return subj unless subj.respond_to?(:class_eval)
      return ___create_interface_proxy_for___(subj) unless subj.respond_to?(:new)
      
      subj.new
    end

    def ___collect_members___(subj)
      clr_type = subj.to_clr_type

      properties = clr_type.collect_interface_properties
      methods = clr_type.collect_interface_methods

      proxy_members = methods.collect { |mi| mi.name.underscore }
      proxy_members += properties.collect { |pi| pi.name.underscore }
      proxy_members += properties.select { |pi| pi.can_write }.collect { |pi| "#{pi.name.underscore}=" }      
    end

    def ___create_interface_proxy_for___(subj)
      proxy_members = ___collect_members___(subj)

      klass = Object.const_set(___class_name___(subj), Class.new)
      klass.class_eval do
        include subj

        proxy_members.each do |mem|
          define_method mem.to_s.to_sym do |*args|
            #just a stub
          end
        end
      end

      klass.new
    end
    
  end
  
  

end