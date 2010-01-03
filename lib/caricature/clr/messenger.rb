module Caricature

  # Encapsulates sending messages to CLR class or instance isolations
  class ClrClassMessenger < Messenger

    protected
    
      # deliver the message to the receiving isolation
      def internal_deliver(mode, method_name, return_type, *args, &b)   
        exp = expectations.find(method_name, mode, *args)
        bl = record_call(method_name, mode, exp, *args, &b)
        is_value_type = return_type && return_type != System::Void.to_clr_type && return_type.is_value_type 
        res = nil
        if exp
          block = exp.block || b
          res = instance.__send__(method_name, *args, &block) if exp.super_before?
          exp.event_recorder do |ev_nm, ev_ar, ev_h|
            recorder.record_event_raise ev_nm, mode, *ev_ar, &ev_h if ev_nm
          end if recorder && exp
          res = exp.execute *args, &bl
          res = instance.__send__(method_name, *args, &block) if !exp.super_before? and exp.call_super?
        end
        res ||= System::Activator.create_instance(return_type) if is_value_type     
        res
      end

  end

  # Encapsulates sending messages to CLR interface isolations
  class ClrInterfaceMessenger < Messenger

    protected

      # deliver the message to the receiving isolation
      def internal_deliver(mode, method_name, return_type, *args, &b)    
        res = nil                                               
        is_value_type = return_type && return_type != System::Void.to_clr_type && return_type.is_value_type
        exp = expectations.find(method_name, mode, *args)
        exp.event_recorder do |ev_nm, ev_ar, ev_h|
          recorder.record_event_raise ev_nm, mode, *ev_ar, &ev_h if ev_nm
        end if recorder && exp
        bl = record_call(method_name, mode, exp, *args, &b)
        res = exp.execute *args, &bl if exp
        res ||= System::Activator.create_instance(return_type) if is_value_type  
        res
      end

  end

end