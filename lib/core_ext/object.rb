class Object

  # returns whether this object is a clr_type.
  # if it has a CLR type in one of its ancestors
  def is_clr_type?
    self.class.is_clr_type?
  end
  
end