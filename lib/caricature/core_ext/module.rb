class Module

  # Removes all but the containing modules from this module's name
  def demodulize
    self.to_s.gsub(/^.*::/, '')
  end

  # indicates whether this type has a CLR type in its ancestors
  def clr_type?
    !self.to_clr_type.nil? ||
            self.included_modules.any? {|mod| !mod.to_clr_type.nil? } ||
            self.ancestors.any? { |mod| !mod.to_clr_type.nil? }
  end

end