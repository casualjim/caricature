class Should
  
  def have_received?(name, &b)
    be(name) { |obj, *args| obj.did_receive?(name, &b).successful? }
  end
  
  def have_raised_event?(name, &b)
    be(name) { |obj, *args| obj.did_raise_event?(name, &b).successful? }
  end if defined?(IRONRUBY_VERSION)  
  
  def satisfy(*args, &block)
    if args.size == 1 && String === args.first
      description = args.shift
    else
      description = ""
    end
    r=nil
    err = nil
    begin
      r = block.call(@object, *args)
    rescue Caricature::ArgumentMatchError => e
      err =e 
    end
    if Bacon::Counter[:depth] > 0
      Bacon::Counter[:requirements] += 1
      raise (err.is_a?(Caricature::ArgumentMatchError) ? err : Bacon::Error.new(:failed, description)) unless @negated ^ r
      r
    else
      @negated ? !r : !!r
    end
  end

end

module Caricature

  # Describes a verification of a method call.
  # This corresponds kind of to an assertion
  class Verification
    

    # indicate that this method verification is successful
    def successful?
      a = any_args? ? [:any] : @args
      res = @recorder.was_called?(@method_name, @block_args, @mode, *a)
      raise Caricature::ArgumentMatchError.new(:failed, self.error) unless res
      res
    end


  end
if defined?(IRONRUBY_VERSION)
  class EventVerification
    
    # indicate that this event verification is successful
    def successful?
      a = any_args? ? [:any] : @args
      res = @recorder.event_raised?(@event_name, @mode, *a)
      raise Caricature::ArgumentMatchError.new(:failed, self.error) unless res
      res
    end
    
  end
  
  # class ClrInterfaceIsolator
  #     def
  #   end
end
  
  class ArgumentMatchError < Bacon::Error; 
  
  end

end

