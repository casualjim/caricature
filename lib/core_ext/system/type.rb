module System

  class Type

    # collects all the methods defined on an interface and its parents
    def collect_interface_methods
      iface_methods = []
      iface_methods += self.get_interfaces.collect { |t| t.collect_interface_methods }
      self.get_methods + iface_methods.flatten
    end

    # collects the properties defined on an interface an its parents
    def collect_interface_properties
      iface_properties = []
      iface_properties += self.get_interfaces.collect { |t| t.collect_interface_properties }
      self.get_properties + iface_properties.flatten
    end

    def collect_interface_events
      iface_events = []
      iface_events += self.get_interfaces.collect { |t| t.collect_interface_events }
      self.get_events + iface_events.flatten.uniq
    end

  end

end