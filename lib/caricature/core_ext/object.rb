class Object

  # returns whether this object is a clr_type.
  # if it has a CLR type in one of its ancestors
  def clr_type?
    self.class.clr_type?
  end

  # returns the clr type of this object if any
  def to_clr_type
    self.class.to_clr_type
  end

  # defines a class method on an object
  def define_cmethod(name, &blk)
    (
    class << self;
      self;
    end).instance_eval { define_method name, &blk }
  end

 def isolate(name=nil, recorder = Caricature::MethodCallRecorder.new, expectations = Caricature::Expectations.new, &block)
    iso = Caricature::Isolation.for(self, recorder, expectations)
    return iso unless name
    if block
      if block.arity > 0
        @expectation = iso.when_receiving(name, &block)
      else
        @expectation = iso.when_receiving(name)
        instance_eval &block
      end
    end
    iso
  end
  alias_method :when_receiving, :isolate
  alias_method :mock, :isolate
  alias_method :stub, :isolate

  # tell the expectation which arguments it needs to respond to
  # there is a magic argument here +any+ which configures
  # the expectation to respond to any arguments
  def with(*ags, &b)
    @expectation.with(*ags, &b)
    self
  end

  # tell the expectation it needs to return this value or the value returned by the block
  # you provide to this method.
  def returns(value=nil, &b)
    @expectation.return(value, &b)
    self
  end

  # Sets up arguments for the block that is being passed into the isolated method call
  def pass_block(*ags, &b)
    @expectation.pass_block(*ags, &b)
    self
  end

  # tell the expectation it needs to raise an error with the specified arguments
  def raise_error(*args)
    @expectation.raise(*args)
    self
  end

  # tell the expectation it needs to call the super before the expectation exectution
  def super_before(&b)
    @expectation.super_before(&b)
    self
  end

  # tell the expectation it needs to call the super after the expecation execution
  def super_after(&b)
    @expectation.super_after &b
    self
  end
end