module Caricature

  # A recording of an argument variation.
  class ArgumentRecording

    # contains the arguments of the recorded parameters
    attr_accessor :args

    # contains the block for the recorded parameters
    attr_accessor :block

    # the number of the call that has the following parameters
    attr_accessor :call_number

    def initialize(args=[], call_number=1, block=nil)
      @args = args
      @block = block
      @call_number = call_number
    end

    # compares one argument variation to another.
    # Also takes an array as an argument
    def ==(other)
      other = self.class.new(other) if other.respond_to?(:each)
      return true if other.args.first == :any
      other.args == args
    end
  end

  # A recording that represents a method call
  # it contains argument variations that can be matched too
  class MethodCallRecording

    # gets or sets the method name
    attr_accessor :method_name

    # gets or sets the amount of times the method was called
    attr_accessor :count

    # gets or sets the arguments for this method call
    attr_accessor :args

    # gets or sets the block for this method call
    attr_accessor :block

    def initialize(method_name, count=0)
      @method_name = method_name
      @count = count
      @variations = []
    end

    # add args
    def args
      @variations
    end

    # indicates if it has an argument variation
    def has_argument_variations?
      @variations.size > 1
    end

    # add an argument variation
    def add_argument_variation(args, block)
      variation = find_argument_variations args
      @variations << ArgumentRecording.new(args, @variations.size+1, block) if variation == []
    end

    # finds an argument variation that matches the provided +args+
    def find_argument_variations(args)
      return @variations if args.first == :any
      @variations.select { |ar| ar.args == args }
    end
  end

  # The recorder that will collect method calls and provides an interface for finding those recordings
  class MethodCallRecorder

    # gets the collection of method calls. This is a hash with the method name as key
    attr_reader :method_calls

    def initialize
      @method_calls = {}
    end

    # records a method call or increments the count of how many times this method was called.
    def record_call(method_name, *args, &block)
      mn_sym = method_name.to_s.to_sym
      method_calls[mn_sym] ||= MethodCallRecording.new method_name
      mc = method_calls[mn_sym]
      mc.count += 1
      mc.add_argument_variation args, block 
    end

    # returns whether the method was actually called with the specified constraints
    def was_called?(method_name, *args)
      mc = method_calls[method_name.to_s.to_sym]
      if mc
        return mc.find_argument_variations(args).first == args        
      else
        return !!mc
      end
    end

    # indexer that gives you access to the recorded method by method name
    def [](method_name)
      method_calls[method_name.to_s.to_sym]
    end

    # returns the number of different methods that has been recorderd
    def size
      @method_calls.size
    end
  end


end