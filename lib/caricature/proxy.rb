module Caricature

  # A proxy to Ruby objects that records method calls
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

  # A proxy to CLR objects that records method calls.
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