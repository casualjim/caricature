class Class

  # removes all the modules from this class name
  def demodulize
    self.to_s.gsub(/^.*::/, '')
  end

  # indicates whether this type has a CLR type in its ancestors
  def clr_type?
    !self.to_clr_type.nil? ||
            self.included_modules.any? {|mod| !mod.to_clr_type.nil? } ||
            self.ancestors.reject {|mod| mod == Object }.any? { |mod| !mod.to_clr_type.nil? }
  end

end