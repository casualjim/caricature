class Hash

  # Destructively convert all keys which respond_to?(:to_sym) to symbols. Works recursively if given nested hashes.
  def symbolize_keys!
    each do |k,v|
      sym = k.respond_to?(:to_sym) ? k.to_sym : k
      self[sym] = Hash === v ? v.symbolize_keys! : v
      delete(k) unless k == sym
    end
    self
  end

end