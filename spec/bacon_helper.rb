$: << File.dirname(__FILE__) + "/bin"
$: << File.dirname(__FILE__) + "/../lib"

require "caricature"
require 'bacon'
require 'mscorlib'




load_assembly 'ClrModels'

class Soldier

  def name
    "Tommy Boy"
  end

  def to_s
    "I'm a soldier"
  end

end

module Caricature

  module InterfaceIncludingModule
    include ClrModels::IWarrior
  end

  module PureRubyModule
    
  end

  module RubyModuleIncludingModule
    include PureRubyModule
  end

  module InterfaceUpTheWazoo
    include InterfaceIncludingModule
  end

  class InterfaceIncludingClass
    include ClrModels::IWarrior
  end

  class SubClassingClrClass < ClrModels::Ninja

  end

  class InterfaceUpTheWazooClass
    include InterfaceUpTheWazoo
  end

  class SubclassingRubyClass < Soldier

  end

  class ModuleIncludingClass
    include RubyModuleIncludingModule
  end
end

