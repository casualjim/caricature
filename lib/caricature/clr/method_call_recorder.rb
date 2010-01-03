module Caricature
  
   # A recording that represents an event raise
   # it contains argument variations that can be matched too
   class EventRaiseRecording

     # gets or sets the event name
     attr_accessor :event_name

     # gets or sets the amount of times the event was raised
     attr_accessor :count

     # gets or sets the arguments for this event raise
     attr_accessor :args

     # gets or sets the block for this event raise
     attr_accessor :handler

     # Initializes a new instance of a method call recording
     # every time a method gets called in an isolated object
     # this gets stored in the method call recorder
     # It expects a +method_name+ at the very least.
     def initialize(event_name, count=0)
       @event_name = event_name
       @count = count
       @variations = []
     end

     # add args
     def args
       @variations
     end

     # indicates if it has an argument variation
     def has_argument_variations?
       @variations.size > 1
     end

     # add an argument variation
     def add_argument_variation(args, block)
       variation = find_argument_variations args
       if variation.empty?
         @variations << ArgumentRecording.new(args, @variations.size+1, block) if variation == []
       else
         variation.first.call_number += 1
       end
     end

     # finds an argument variation that matches the provided +args+
     def find_argument_variations(args)
       return @variations if args.first.is_a?(Symbol) and args.last == :any
       @variations.select { |ar| ar.args == args }
     end
     
   end
  
  class MethodCallRecorder
    
    def event_raises
      @event_raises ||= {}
    end
    
    def record_event_raise(event_name, mode, *args, &handler)
      en_sym = event_name.to_sym
      event_raises[mode] ||= {}
      ev = (event_raises[mode][en_sym] ||= EventRaiseRecording.new(event_name))
      ev.count += 1
      ev.add_argument_variation args, handler
    end
    
    def event_error
      @event_error
    end
    
    # returns whether the event was actually raised with the specified constraints
    def event_raised?(event_name, mode = :instance, *args)
      mc = event_raises[mode][event_name.to_s.to_sym]  
      if mc
        vari = mc.find_argument_variations(args)
        result = vari.any? { |agv| agv == args }
        return result if result
        if args.size == 1 and args.last.is_a?(Hash)
          result = vari.any? do |agv|
            agv.args.last.is_a?(Hash) and args.last.all? { |k, v| agv.args.last[k] == v }
          end
        end
        @event_error = "Event Arguments don't match for #{event_name}.\n\nYou expected:\n#{args.join(", ")}.\n\nI did find the following variations:\n#{mc.args.collect {|ar| ar.args.join(', ') }.join(' and ')}" unless result
        result
      else
        @event_error = "Couldn't find an event with name #{event_name}"
        return !!mc
      end
    end
    
  end
  
end