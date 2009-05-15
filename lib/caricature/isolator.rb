module Caricature

  # Groups the methods for interception together
  # this is a mix-in for the created isolations for classes
  module Interception

    # Replaces the call to the proxy with the one you create with this method.
    # You can specify more specific criteria in the block to configure the expectation.
    #
    # Example:
    #
    # an_isolation.when_receiving(:a_method) do |method_call|
    #   method_call.with(3, "a").return(5)
    # end
    #
    # is equivalent to:
    #
    # an_isolation.when_receiving(:a_method).with(3, "a").return(5)
    #
    # You will most likely use this method when you want your stubs to return something else than +nil+
    # when they get called during the run of the test they are defined in.
    def when_receiving(method_name, &block)
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
    # an_isolation.did_receive?(:a_method) do |method_call|
    #   method_call.with(3, "a")
    # end.should.be.true?
    #
    # You will probably be using this method only when you're interested in whether a method has been called
    # during the course of the test you're running.
    def did_receive?(method_name, &block)
      verification = Verification.new(method_name, @___recorder___)
      block.call verification unless block.nil?
      verification
    end

  end

  # A base class for +Isolator+ objects
  # to stick with the +Isolation+ nomenclature the strategies for creating isolations
  # are called isolators.
  # An isolator functions as a barrier between the code in your test and the
  # underlying type/instance. It allows you to take control over the value
  # that is returned from a specific method, if you want to pass the method call along to
  # the underlying instance etc.  It also contains the ability to verify if a method
  # was called, with which arguments etc.
  class Isolator
    class << self

      # Creates the actual proxy object for the +subject+ and initializes it with a
      # +recorder+ and +expectations+
      # This is the actual isolation that will be used to in your tests.
      # It implements all the methods of the +subject+ so as long as you're in Ruby
      # and just need to isolate out some classes defined in a statically compiled language
      # it should get you all the way there for public instance methods at this point.
      # when you're going to isolation for usage within a statically compiled language type
      # then  you're bound to most of their rules. So you need to either isolate interfaces
      # or mark the methods you want to isolate as virtual in your implementing classes.
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
        raise NotImplementedError, "implement this method in an inheritor"
      end

      def initialize_proxy(klass, inst, recorder, expectations)
        pxy = klass.new
        pxy.instance_variable_set("@___super___", inst)
        pxy.instance_variable_set("@___recorder___", recorder)
        pxy.instance_variable_set("@___expectations___", expectations)

        pxy
      end


    end
  end

  # A proxy to Ruby objects that records method calls
  # this implements all the instance methods that are defined on the class.
  class RubyIsolator < Isolator

    class << self

      protected

      def create_proxy(subj, recorder, expectations)
        klass = subj.respond_to?(:class_eval) ? subj : subj.class
        instance = subj.respond_to?(:class_eval) ? subj.new : subj
        pxy = create_ruby_proxy_for klass
        res = initialize_proxy pxy, instance, recorder, expectations
        res
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
  # this implements all the public instance methods of the class when you use it in ruby code
  # When you use it in a CLR class you're bound to CLR rules and it only overrides the methods
  # that are marked as virtual. We also can't isolate static or sealed types at the moment. 
  class ClrIsolator < Isolator

    class << self
      protected

      def create_proxy(subj, recorder, expectations)
        instance = nil
        sklass = subj
        unless subj.respond_to?(:class_eval)
          sklass = subj.class
          instance = subj 
        end

        pxy = create_clr_proxy_for(sklass)
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



    end

  end

  # An +Isolator+ for CLR interfaces.
  # this implements all the methods that are defined on the interface.
  class ClrInterfaceIsolator < Isolator
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