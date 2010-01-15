class String

  # converts a camel cased word to an underscored word
  def underscore
    self.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
  end

  # Gets the constant when it is defined that corresponds to this string
  def classify
    Object.const_get self
  end
  
end