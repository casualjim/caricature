module Caricature
  
  # Syntax for the expectation builder and expectation
  # to define an event on the expectation.
  module EventExpectationSyntax
    
    # tell the expectation it needs to raise an event when this method is called
    def raise_event(name, *ags, &b)
      collected.merge!(:event_name => name, :event_args => ags, :event_handler => b)
    end
    
    # raises the events that has been registered on the object at runtime
    def raise_subscriptions
      collected[:raise_subscriptions] = true
    end
    
  end
  
  
  # Adds event support to the expectation
  # this is only applicable to clr isolations and not
  # to ruby isolations
  class Expectation
    
    include EventExpectationSyntax
    
    def initialzie(options={})
      collected[:raise_subscriptions] = false
      super
    end
    
    # the block that will be used
    def event_name
      collected[:event_name]
    end
    
    # the block that will be used
    def event_args
      collected[:event_args]
    end
    
    # the block that will be used# the block that will be used
    def event_handler
      collected[:event_handler]
    end
    
    # the events attached to the context
    def events
      collected[:events] ||= {}
    end
    
    # Set the registered events for this expectation
    def events=(evts)
      collected[:events]=evts
    end
    
    # indicates whether this expectation has an event that needs to be raised
    def raises_event?
      !!collected[:event_name]
    end
    
    # indicates whether this expectation has an event handler to be called 
    def has_event_handler?
      !!collected[:event_handler]
    end
    
    # indicates whether to raise the registered event handlers
    def raises_registered?
      !!collected[:raise_subscriptions]
    end
    
    def to_s #:nodoc:
      "<Caricature::Expecation, method_name: #{method_name}, args: #{args}, error args: #{error_args}, event: #{event_name}>"
    end
    alias :inspect :to_s
    
    private 
    
    def do_event_raise #:nodoc:
      if raises_event?
        ags = collected[:event_args]
        collected[:event_callback].call *ags if has_event_handler?
        events[collected[:event_name]].each { |evt| evt.call *ags } if raises_registered? or not has_event_handler?
      end
    end
  end

  ExpectationBuilder.send :include, EventExpectationSyntax
end