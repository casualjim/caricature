class Array

  # Converts an array of values to a hash.
  # the even indexes are the hash keys
  # the odd indexes are the hash values
  def to_h
    h = Hash[*self]
    h.symbolize_keys!    
  end
end