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

  def isolate(name=nil, recorder = Caricature::MethodCallRecorder.new, expectations = Caricature::Expectations.new, &block)
    iso = Caricature::Isolation.for(self, recorder, expectations)
    return iso unless name
    if block
      if block.arity > 0
        @expectation = iso.when_class_receives(name, &block)
      else
        @expectation = iso.when_class_receives(name)
        instance_eval &block
      end
    end
    iso
  end
  alias_method :when_receiving, :isolate
  alias_method :mock, :isolate
  alias_method :stub, :isolate

end