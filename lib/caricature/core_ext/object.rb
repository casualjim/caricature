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
    (class << self; self; end).instance_eval { define_method name, &blk }
  end
  
end