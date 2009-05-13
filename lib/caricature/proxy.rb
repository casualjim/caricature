module Caricature

  # A proxy to Ruby objects that records method calls
  class RecordingProxy

    class << self
      def for(subject, recorder, expectations=Expectations.new)
        subj = create_proxy(subject, recorder, expectations)
        subj
      end

      protected

      def class_name(subj)
        nm = subj.respond_to?(:class_eval) ? subj.demodulize : subj.class.demodulize
        @class_name = "#{nm}#{System::Guid.new_guid.to_string('n')}"
        @class_name
      end

      def create_proxy(subj, recorder, expectations)
        klass = subj.respond_to?(:class_eval) ? subj : subj.class
        instance = subj.respond_to?(:class_eval) ? subj.new : subj
        pxy = create_ruby_proxy_for klass
        res = initialize_proxy pxy, instance, recorder, expectations
        res
      end

      def initialize_proxy(klass, inst, recorder, expectations)
        pxy = klass.new
        pxy.instance_variable_set("@___super___", inst)
        pxy.instance_variable_set("@___recorder___", recorder)
        pxy.instance_variable_set("@___expectations___", expectations)

        pxy
      end

      def create_ruby_proxy_for(subj)

        klass = Object.const_set(class_name(subj), Class.new(subj))
        klass.class_eval do

          (subj.instance_methods - Object.instance_methods).each do |mn|
            define_method mn do |*args|
              exp = @___expectations___.find(nm, args)
              if exp
                sup = @___super___.instance_variable_get("@___super___")
                sup.__send__(nm, *args, &b) if exp.super_before?
                exp.execute
                sup.__send__(nm, *args, &b) if !exp.super_before? and exp.has_super?
              else
                @___super___.__send__(m, *a, &b)
              end
            end
          end

        end

        klass
      end
    end


  end

  # A proxy to CLR objects that records method calls.
  class RecordingClrProxy < RecordingProxy

    class << self
      protected

      def create_proxy(subj, recorder, expectations)
        pxy, instance = nil
        sklass = subj
        unless subj.respond_to?(:class_eval)
          sklass = subj.class
          instance = subj 
        end
        pxy = create_interface_proxy_for(sklass) unless sklass.respond_to?(:new)

        pxy ||= create_clr_proxy_for(sklass)
        instance ||= pxy.new
        initialize_proxy pxy, instance, recorder, expectations
      end

      def  create_clr_proxy_for(subj)
        clr_type = subj.to_clr_type
        members = clr_type.get_methods.collect { |mi| [mi.name.underscore, mi.return_type] }
        members += clr_type.get_properties.collect { |pi| [pi.name.underscore, pi.property_type] }
        members += clr_type.get_properties.select{|pi| pi.can_write }.collect { |pi| ["#{pi.name.underscore}=", nil] }

        klass = Object.const_set(class_name(subj), Class.new(subj))
        klass.class_eval do

          include Interception
          
          def ___super___ 
            @___super___
          end
                    
          members.each do |mem|
            nm = mem[0].to_s.to_sym
            define_method nm do |*args|
              b = nil
              b = Proc.new { yield } if block_given?
              ___invoke_method_internal___(nm, mem[1], *args, &b)
            end unless nm == :to_string
          end
               

          private

            def ___invoke_method_internal___(nm, return_type, *args, &b)
              puts "\nfor method #{nm} we have expectations #@___expectations___"
              exp = @___expectations___.find(nm, args)
              if exp
                @___super___.__send__(nm, *args, &b) if exp.super_before?
                exp.execute
                @___super___.__send__(nm, *args, &b) if !exp.super_before? and exp.has_super?
              else
                @___recorder___.record_call nm, *args
                rt = nil
                is_value_type = return_type && return_type != System::Void.to_clr_type && return_type.is_value_type
                rt = System::Activator.create_instance(return_type) if is_value_type
                rt
              end
            end

        end

        klass
      end

      def collect_members(subj)
        clr_type = subj.to_clr_type

        properties = clr_type.collect_interface_properties
        methods = clr_type.collect_interface_methods

        proxy_members = methods.collect { |mi| [mi.name.underscore, mi.return_type] }
        proxy_members += properties.collect { |pi| [pi.name.underscore, pi.property_type] }
        proxy_members += properties.select { |pi| pi.can_write }.collect { |pi| ["#{pi.name.underscore}=", nil] }
      end

      def create_interface_proxy_for(subj)
        proxy_members = collect_members(subj)

        klass = Object.const_set(class_name(subj), Class.new)
        klass.class_eval do
          include subj
          include Interception

          proxy_members.each do |mem|
            nm = mem[0].to_s.to_sym
            define_method nm do |*args|
              b = nil
              b = Proc.new { yield } if block_given?
              ___invoke_method_internal___(nm, mem[1], *args, &b)
            end
          end

          private

            def ___invoke_method_internal___(nm, return_type, *args, &b)
              exp = @___expectations___.find(nm, args)
              if exp
                exp.execute
              else
                @___recorder___.record_call nm, *args
                rt = nil
                rt = System::Activator.create_instance(return_type) if return_type && return_type != System::Void.to_clr_type && return_type.is_value_type
                rt
              end
            end

        end

        klass
      end

    end

  end



end