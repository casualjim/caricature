module Caricature

  # A collection of expectations with some methods to make it easier to work with them.
  # It allows you to add and find expectations based on certain criteria.
  class Expectations

    #initializes a new empty instance of the +Expectation+ collection
    def initialize
      @inner = []
    end

    # Adds an expectation to this collection. From then on it can be found in the collection.
    def <<(expectation)
      @inner << expectation
    end

    # Finds an expectation in the collection. It matches by +method_name+ first.
    # Then it tries to figure out if you care about the arguments. You can say you don't care by providing
    # the symbol +:any+ as first argument to this method. When you don't care the first match is being returned
    # When you specify arguments other than +:any+ it will try to match the specified arguments in addition
    # to the method name. It will then also return the first result it can find.
    def find(method_name, *args)
      candidates = @inner.select { |exp| exp.method_name.to_s.to_sym == method_name.to_s.to_sym }
      is_single = args.empty? || args.first == :any || (candidates.size == 1 && candidates.first.any_args?)
      return candidates.first if is_single

      second_pass = candidates.select {|exp| exp.args == args }
      second_pass.first
    end

  end

  # contains the syntax for building up an expectation
  # This is shared between the +ExpecationBuilder+ and the +Expectation+
  module ExpectationSyntax
    # tell the expection which arguments it needs to respond to
    # there is a magic argument here +any+ which configures
    # the expectation to respond to any arguments
    def with(*args)
      @any_args = false unless args.first == :any
      @args = args
      self
    end

    # tell the expectation it nees to return this value or the value returned by the block
    # you provide to this method.
    def return(value=nil)
      @return_value = value
      @return_value ||= yield if block_given?
      self
    end

    # tell the expectation it needs to raise an error with the specified arguments
    def raise(*args)
      @error_args = args
      self
    end

    # tell the expecation it needs to call the super before the expectation exectution
    def super_before
      @super = :before
    end

    # tell the expectation it needs to call the super after the expecation execution
    def super_after
      @super = :after
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

    # Initializes a new instance of an expectation
    def initialize(method_name, args, error_args, return_value, super_mode)
      @method_name, @args, @error_args, @return_value, @super =
              method_name, args, error_args, return_value, super_mode
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
    
    # executes this expectation with its configuration
    def execute(*margs)
      ags = any_args? ? (margs.empty? ? :any : margs) : args
      raise *@error_args if has_error_args?
      return return_value if has_return_value?
      nil
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
      @method_name, @return_value, @super, @block, @error_args, @args, @any_args = 
              method_name, nil, nil, nil, nil, [], true
    end



    # build up the expectation with the provided arguments
    def build
      Expectation.new @method_name, @args, @error_args, @return_value, @super
    end

  end

end