module Caricature

  # A collection of expectations with some methods to make it easier to work with them.
  # It allows you to add and find expectations based on certain criteria.
  class Expectations

    #initializes a new empty instance of the +Expectation+ collection
    def initialize
      @instance_expectations = []
      @class_expectations = []
    end

    # Adds an expectation to this collection. From then on it can be found in the collection.
    def add_expectation(expectation, mode=:instance)
      @instance_expectations << expectation unless mode == :class
      @class_expectations << expectation if mode == :class
    end

    # Finds an expectation in the collection. It matches by +method_name+ first.
    # Then it tries to figure out if you care about the arguments. You can say you don't care by providing
    # the symbol +:any+ as first argument to this method. When you don't care the first match is being returned
    # When you specify arguments other than +:any+ it will try to match the specified arguments in addition
    # to the method name. It will then also return the first result it can find.
    def find(method_name, mode=:instance, *args)
      expectations = mode == :class ? @class_expectations : @instance_expectations

      candidates = expectations.select { |exp| exp.method_name.to_s.to_sym == method_name.to_s.to_sym }
      with_arguments_candidates = candidates.select { |exp| exp.args == args }
      
      with_arguments_candidates.first || candidates.select { |exp| exp.any_args?  }.first
    end

  end

  # contains the syntax for building up an expectation
  # This is shared between the +ExpecationBuilder+ and the +Expectation+
  module ExpectationSyntax
    
    # tell the expection which arguments it needs to respond to
    # there is a magic argument here +any+ which configures
    # the expectation to respond to any arguments
    def with(*ags, &b)
      collected[:any_args] = ags.first.is_a?(Symbol) and ags.first == :any
      collected[:args] = ags   
      collected[:callback] = b unless b.nil?
      self
    end

    # tell the expectation it nees to return this value or the value returned by the block
    # you provide to this method.
    def return(value=nil, &b)
      collected[:return_value] = value
      collected[:return_callback] = b if b
      self
    end

    # Sets up arguments for the block that is being passed into the isolated method call
    def pass_block(*ags, &b)
      collected[:any_block_args] = ags.first.is_a?(Symbol) and args.first == :any
      collected[:block_args] = ags
      collected[:block_callback] = b unless b.nil?
      self
    end

    # tell the expectation it needs to raise an error with the specified arguments
    alias_method :actual_raise, :raise
    def raise(*args)
      collected[:error_args] = args
      self
    end
    
    # tell the expecation it needs to call the super before the expectation exectution
    def super_before(&b)
      collected[:super] = :before
      collected[:block] = b if b
      self
    end
    
    # tell the expectation it needs to call the super after the expecation execution
    def super_after(&b)
      collected[:super] = :after
      collected[:block] = b if b
      self
    end

    # indicates whether this expectation should match with any arguments
    # or only for the specified arguments
    def any_args?
      collected[:any_args]
    end
    
    
    private
    
      def collected
        @collected ||= {}
      end
  end

  # A description of an expectation.
  # An expectation has the power to call the proxy method or completely ignore it
  class Expectation

    include ExpectationSyntax

    # the error_args that this expectation will raise an error with
    def error_args
      collected[:error_args]
    end

    # the value that this expecation will return when executed
    def return_value
      collected[:return_value]
    end

    # indicator for the mode to call the super +:before+, +:after+ and +nil+
    def super 
      collected[:super]
    end  

    # contains the callback if one is given
    def callback
      collected[:callback]
    end

    # contains the callback that is used to return the value when this expectation
    # is executed
    def return_callback
      collected[:return_callback]
    end

    # contains the arguments that will be passed on to the block
    def block_args
      collected[:block_args]
    end

    # The block that will be used as value provider for the block in the method
    def block_callback
      collected[:block_callback]
    end

    # the block that will be used
    def block
      collected[:block]
    end
    
    # sets the block callback 
    def block=(val)
      collected[:block] = val
    end
    
    # gets the method_name to which this expectation needs to listen to
    def method_name 
      collected[:method_name]
    end
    
    # the arguments that this expectation needs to be constrained by
    def args
      collected[:args]
    end
    
    # Initializes a new instance of an expectation
    def initialize(options={})
      collected[:any_args] = true
      collected.merge!(options)
    end
    
    # indicates whether this expecation will raise an event.
    def has_error_args?
      !collected[:error_args].nil?
    end

    # indicates whether this expectation will return a value.
    def has_return_value?
      !collected[:return_value].nil?
    end

    # call the super before the expectation
    def super_before?
      collected[:super] == :before
    end

    # indicates whether super needs to be called somewhere
    def call_super?
      !collected[:super].nil?
    end      
    
    # indicates whether this expecation has a callback it needs to execute
    def has_callback? 
      !collected[:callback].nil?
    end
    
    # indicates whether this expectation has a block as value provider for the method call block
    def has_block_callback?
      !collected[:block_callback].nil?
    end

    # a flag to indicate it has a return value callback
    def has_return_callback?
      !collected[:return_callback].nil?
    end
    
    # executes this expectation with its configuration
    def execute(*margs,&b)
      ags = any_args? ? :any : (margs.empty? ? collected[:args] : margs)
      do_raise_error
      do_callback(ags)
      do_block_callback(&b)
      do_event_raise if respond_to?(:events)

      return collected[:return_callback].call(*margs) if has_return_callback?
      return return_value if has_return_value? 
      nil
    end

    def to_s #:nodoc:
      "<Caricature::Expecation, method_name: #{method_name}, args: #{args}, error args: #{error_args}>"
    end
    alias :inspect :to_s
    
    
    private 
    
    def do_raise_error #:nodoc:
      actual_raise *collected[:error_args] if has_error_args?
    end
    
    def do_callback(ags) #:nodoc:
      callback.call(*ags) if has_callback?
    end
    
    def do_block_callback(&b) #:nodoc:
      if b
        ags = has_block_callback? ? collected[:block_callback].call : collected[:block_args]
        b.call(*ags)
      end
    end
    
    
  end

  # Constructs the expecation object.
  # Used as a boundary between the definition and usage of the expectation
  class ExpectationBuilder

    include ExpectationSyntax

    # initialises a new instance of the expectation builder
    # this builder is passed into the block to allow only certain
    # operations in the block.
    def initialize(method_name)
      @collected = { :method_name => method_name, :args => [], :any_args => true }
    end



    # build up the expectation with the provided arguments
    def build
      Expectation.new collected
    end

  end

end