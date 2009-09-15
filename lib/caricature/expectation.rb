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
    def with(*args, &b)
      @any_args = args.first.is_a?(Symbol) and args.first == :any
      @args = args   
      @callback = b unless b.nil?
      self
    end

    # tell the expectation it nees to return this value or the value returned by the block
    # you provide to this method.
    def return(value=nil, &b)
      @return_value = value
      @return_callback = b if b
      self
    end

    # Sets up arguments for the block that is being passed into the isolated method call
    def pass_block(*args, &b)
      @any_block_args = args.first.is_a?(Symbol) and args.first == :any
      @block_args = args
      @block_callback = b unless b.nil?
      self
    end

    # tell the expectation it needs to raise an error with the specified arguments
    alias_method :actual_raise, :raise
    def raise(*args)
      @error_args = args
      self
    end

    # tell the expecation it needs to call the super before the expectation exectution
    def super_before(&b)
      @super = :before
      @block = b if b
      self
    end

    # tell the expectation it needs to call the super after the expecation execution
    def super_after(&b)
      @super = :after
      @block = b if b
      self
    end

    # indicates whether this expectation should match with any arguments
    # or only for the specified arguments
    def any_args?
      @any_args
    end
  end

  # A description of an expectation.
  # An expectation has the power to call the proxy method or completely ignore it
  class Expectation

    include ExpectationSyntax

    # gets the method_name to which this expectation needs to listen to
    attr_reader :method_name

    # the arguments that this expectation needs to be constrained by
    attr_reader :args

    # the error_args that this expectation will raise an error with
    attr_reader :error_args

    # the value that this expecation will return when executed
    attr_reader :return_value

    # indicator for the mode to call the super +:before+, +:after+ and +nil+
    attr_reader :super   
                         
    # contains the callback if one is given
    attr_reader :callback

    # contains the callback that is used to return the value when this expectation
    # is executed
    attr_reader :return_callback

    # contains the arguments that will be passed on to the block
    attr_reader :block_args

    # The block that will be used as value provider for the block in the method
    attr_reader :block_callback

    # the block that will be used
    attr_accessor :block


    # Initializes a new instance of an expectation
    def initialize(*args)
      @method_name, @args, @error_args, @return_value, @return_callback,
              @super, @callback, @block_args, @block_callback, @block = *args
      @any_args = true
    end

    # indicates whether this expecation will raise an event.
    def has_error_args?
      !@error_args.nil?
    end

    # indicates whether this expectation will return a value.
    def has_return_value?
      !@return_value.nil?
    end

    # call the super before the expectation
    def super_before?
      @super == :before
    end

    # indicates whether super needs to be called somewhere
    def call_super?
      !@super.nil?
    end      
    
    # indicates whether this expecation has a callback it needs to execute
    def has_callback? 
      !@callback.nil?
    end

    # indicates whether this expectation has a block as value provider for the method call block
    def has_block_callback?
      !@block_callback.nil?
    end

    # a flag to indicate it has a return value callback
    def has_return_callback?
      !@return_callback.nil?
    end
    
    # executes this expectation with its configuration
    def execute(*margs,&b)
      ags = any_args? ? (margs.empty? ? :any : margs) : args
      actual_raise *@error_args if has_error_args?    
      callback.call(*ags) if has_callback?

      if b
        if has_block_callback?
          b.call(*@block_callback.call)
        else
          b.call(*@block_args)
        end
      end

      return @return_callback.call(*margs) if has_return_callback?
      return return_value if has_return_value? 
      nil
    end

    def to_s
      "<Caricature::Expecation, method_name: #{method_name}, args: #{args}, error args: #{error_args}>"
    end

    def inspect
      to_s
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
      @method_name, @args, @any_args = method_name, [], true
    end



    # build up the expectation with the provided arguments
    def build
      Expectation.new @method_name, @args, @error_args, @return_value, @return_callback, @super, @callback, @block_args, @block_callback, @block
    end

  end

end