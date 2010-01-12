module PureRubyModule

end

module RubyModuleIncludingModule
  include PureRubyModule
end

class SubclassingRubyClass < Soldier

end

class ModuleIncludingClass
  include RubyModuleIncludingModule
end

if defined? IRONRUBY_VERSION

  module Caricature

    module InterfaceIncludingModule
      include ClrModels::IWarrior
    end


    module InterfaceUpTheWazoo
      include InterfaceIncludingModule
    end

    class InterfaceIncludingClass
      include ClrModels::IWarrior
      
      attr_reader :id
      attr_accessor :name
      
      def is_killed_by(weapon)
        
      end
      
      def attack(target, weapon)
        
      end
      
      def survive_attack_with(weapon)
        
      end
      
    end

    class SubClassingClrClass < ClrModels::Ninja

    end

    class InterfaceUpTheWazooClass
      include InterfaceUpTheWazoo
    end


  end

end