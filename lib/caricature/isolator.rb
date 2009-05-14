module Caricature

  module Interception

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
      @___expectations___ ||= Expectations.new
      builder = ExpectationBuilder.new method_name, @___recorder___
      block.call builder unless block.nil?
      exp = builder.build
      @___expectations___ << exp
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
      verification = Verification.new(method_name, @___recorder___)
      block.call verification unless block.nil?
      verification
    end

  end

  # A proxy to Ruby objects that records method calls
  class RubyIsolator

    class << self
      def for(subject, recorder=MethodCallRecorder.new, expectations=Expectations.new)
        create_proxy(subject, recorder, expectations)        
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

          include Interception

          (subj.instance_methods - Object.instance_methods).each do |mn|
            mn = mn.to_s.to_sym
            define_method mn do |*args|
              b = nil
              b = Proc.new { yield } if block_given?
              ___invoke_method_internal___(mn, *args, &b)
            end
          end

          private

            def ___invoke_method_internal___(nm, *args, &b)
              exp = @___expectations___.find(nm, args)
              if exp
                @___super___.__send__(nm, *args, &b) if exp.super_before?
                exp.execute *args
                @___super___.__send__(nm, *args, &b) if !exp.super_before? and exp.call_super?
              else
                @___recorder___.record_call nm, *args
                nil
              end
            end

        end

        klass
      end
    end


  end

  # A proxy to CLR objects that records method calls.
  class ClrIsolator < RubyIsolator

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
              exp = @___expectations___.find(nm, args)
              if exp
                res = nil
                res = @___super___.__send__(nm, *args, &b) if exp.super_before?
                res = exp.execute *args
                res = @___super___.__send__(nm, *args, &b) if !exp.super_before? and exp.call_super?
                res
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
                return exp.execute
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