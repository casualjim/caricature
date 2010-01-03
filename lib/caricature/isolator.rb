require 'rubygems'
require 'uuidtools'
require File.dirname(__FILE__) + '/messenger'
require File.dirname(__FILE__) + '/descriptor'

module Caricature

  # Groups the methods for interception together
  # this is a mix-in for the created isolations for classes
  module Interception

    # the class methods of this intercepting object
    module ClassMethods

      # the context of this isolation instance.
      # this context takes care of responding to method calls etc.
      def isolation_context
        @___context___
      end

      # Replaces the call to the proxy with the one you create with this method.
      # You can specify more specific criteria in the block to configure the expectation.
      #
      # Example:
      #
      #     an_isolation.class.when_receiving(:a_method) do |method_call|
      #       method_call.with(3, "a").return(5)
      #     end
      #
      # is equivalent to:
      #
      #     an_isolation.class.when_receiving(:a_method).with(3, "a").return(5)
      #
      # You will most likely use this method when you want your stubs to return something else than +nil+
      # when they get called during the run of the test they are defined in.
      def when_receiving(method_name, &block)
        isolation_context.create_class_override method_name, &block
      end

      # Verifies whether the specified method has been called
      # You can specify constraints in the block
      #
      # The most complex configuration you can make currently is one that is constrained by arguments.
      # This is most likely to be extended in the future to allow for more complex verifications.
      #
      # Example:
      #
      #     an_isolation.class.did_receive?(:a_method) do |method_call|
      #       method_call.with(3, "a")
      #     end.should.be.successful
      #
      # is equivalent to:
      #
      #     an_isolation.class.did_receive?(:a_method).with(3, "a").should.be.successful
      #
      # You will probably be using this method only when you're interested in whether a method has been called
      # during the course of the test you're running.
      def did_receive?(method_name, &block)
        isolation_context.class_verify method_name, &block
      end

    end

    # mixes in the class methods of this module when it gets included in a class.
    def self.included(base)
      base.extend ClassMethods
    end

    # the context of this isolation instance.
    # this context takes care of responding to method calls etc.
    def isolation_context
      self.class.isolation_context
    end

    # Replaces the call to the proxy with the one you create with this method.
    # You can specify more specific criteria in the block to configure the expectation.
    #
    # Example:
    #
    #     an_isolation.when_receiving(:a_method) do |method_call|
    #       method_call.with(3, "a").return(5)
    #     end
    #
    # is equivalent to:
    #
    #     an_isolation.when_receiving(:a_method).with(3, "a").return(5)
    #
    # You will most likely use this method when you want your stubs to return something else than +nil+
    # when they get called during the run of the test they are defined in.
    def when_receiving(method_name, &block)
      isolation_context.create_override method_name, &block
    end

    # Replaces the call to the class of the proxy with the one you create with this method.
    # You can specify more specific criteria in the block to configure the expectation.
    #
    # Example:
    #
    #     an_isolation.when_class_receives(:a_method) do |method_call|
    #       method_call.with(3, "a").return(5)
    #     end
    #
    # is equivalent to:
    #
    #     an_isolation.when_class_receives(:a_method).with(3, "a").return(5)
    #
    # You will most likely use this method when you want your stubs to return something else than +nil+
    # when they get called during the run of the test they are defined in.
    def when_class_receives(method_name, &block)
      self.class.when_receiving method_name, &block
    end

    # Verifies whether the specified method has been called
    # You can specify constraints in the block
    #
    # The most complex configuration you can make currently is one that is constrained by arguments.
    # This is most likely to be extended in the future to allow for more complex verifications.
    #
    # Example:
    #
    #     an_isolation.did_receive?(:a_method) do |method_call|
    #       method_call.with(3, "a")
    #     end.should.be.successful
    #
    # is equivalent to:
    #
    #     an_isolation.did_receive?(:a_method).with(3, "a").should.be.successful
    #
    # You will probably be using this method only when you're interested in whether a method has been called
    # during the course of the test you're running.
    def did_receive?(method_name, &block)
      isolation_context.verify method_name, &block
    end

    # Verifies whether the specified class method has been called
    # You can specify constraints in the block
    #
    # The most complex configuration you can make currently is one that is constrained by arguments.
    # This is likely to be extended in the future to allow for more complex verifications.
    #
    # Example:
    #
    #     an_isolation.did_class_receive?(:a_method) do |method_call|
    #       method_call.with(3, "a")
    #     end.should.be.successful
    #
    # is equivalent to:
    #
    #     an_isolation.did_class_receive?(:a_method).with(3, "a").should.be.successful
    #
    # You will probably be using this method only when you're interested in whether a method has been called
    # during the course of the test you're running.
    def did_class_receive?(method_name, &block)
      self.class.did_receive?(method_name, &block)
    end    
    
    # Initializes the underlying subject
    # It expects the constructor parameters if they are needed.
    def with_subject(*args, &b)
      isolation_context.instance = self.class.superclass.new *args 
      b.call self if b
      self
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

    # holds the isolation created by this isolator
    attr_reader :isolation

    # holds the subject of this isolator
    attr_reader :subject

    # holds the descriptor for this type of object
    attr_reader :descriptor

    # creates a new instance of an isolator
    def initialize(context)
      @context = context
    end

    # builds up the isolation class instance
    def build_isolation(klass, inst=nil)
      pxy = create_isolation_for klass
      @isolation = pxy.new
      @subject = inst
      initialize_messenger
    end

    # initializes the messaging strategy for the isolator
    def initialize_messenger
      raise NotImplementedError
    end

    # Creates the new class name for the isolation
    def class_name(subj)
      nm = subj.respond_to?(:class_eval) ? subj.demodulize : subj.class.demodulize
      @class_name = "#{nm}#{UUIDTools::UUID.random_create.to_s.gsub /-/, ''}"
      @class_name
    end

    # Sets up the necessary instance variables for the isolation
    def initialize_isolation(klass, context)
      pxy = klass.new
      pxy.instance_variable_set("@___context___", context)
      pxy
    end
 

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
      def for(context)
        context.recorder ||= MethodCallRecorder.new
        context.expectations ||= Expectations.new
        new(context)
      end
    end
  end

  # A proxy to Ruby objects that records method calls
  # this implements all the instance methods that are defined on the class.
  class RubyIsolator < Isolator

    # implemented template method for creating Ruby isolations
    def initialize(context)
      super
      klass = @context.subject.respond_to?(:class_eval) ? @context.subject : @context.subject.class
      inst = @context.subject.respond_to?(:class_eval) ? nil : @context.subject
      # inst = @context.subject.respond_to?(:class_eval) ? @context.subject.new : @context.subject            
      @descriptor = RubyObjectDescriptor.new klass
      build_isolation klass, inst
    end

    # initializes the messaging strategy for the isolator
    def initialize_messenger
      @context.messenger = RubyMessenger.new @context.expectations, @subject
    end

    # creates the ruby isolator for the specified subject
    def create_isolation_for(subj)
      imembers = @descriptor.instance_members
      cmembers = @descriptor.class_members

      klass = Object.const_set(class_name(subj), Class.new(subj))
      klass.class_eval do

        include Interception

        # access to the proxied subject
        def ___super___
          isolation_context.instance
        end

        imembers.each do |mn|
          mn = mn.name.to_s.to_sym
          define_method mn do |*args|
            b = nil
            b = Proc.new { yield } if block_given?  
            isolation_context.send_message(mn, nil, *args, &b)
          end
        end  
        
        def initialize(*args)  
          self                      
        end 
        
        cmembers.each do |mn|
          mn = mn.name.to_s.to_sym
          define_cmethod mn do |*args|        
            return if mn.to_s =~ /$(singleton_)?method_added/ and args.first.to_s =~ /$(singleton_)?method_added/
            b = nil
            b = Proc.new { yield } if block_given?  
            isolation_context.send_class_message(mn, nil, *args, &b)
          end
        end   

      end

      klass
    end


  end

end