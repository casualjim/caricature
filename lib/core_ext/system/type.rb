module System

  class Type

    def collect_interface_methods
      iface_methods = []
      iface_methods += self.get_interfaces.collect { |t| t.collect_interface_methods }
      self.get_methods + iface_methods.flatten
    end

    def collect_interface_properties
      iface_properties = []
      iface_properties += self.get_interfaces.collect { |t| t.collect_interface_properties }
      self.get_properties + iface_properties.flatten
    end

    
  end

end