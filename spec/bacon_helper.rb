# add some search paths to ironruby
# this first one adds the path with the assemblies
# this enables us not to have to specify a path to the assemblies everywhere.
$: << File.dirname(__FILE__) + "/bin"
# adds the path to the caricature library.
$: << File.dirname(__FILE__) + "/../lib"

# load the caricature library
require "caricature"
require 'caricature/clr'

require 'rubygems'
# load the bacon library
require 'bacon'

# Add the .NET framework
require 'mscorlib'

# load the assembly with the C# code
require 'ClrModels.dll'

class Soldier

  def initialize
    @life = 10
  end

  def name
    "Tommy Boy"
  end

  def to_s
    "I'm a soldier"
  end

  def attack(target, weapon)
    weapon.attack(target)
  end

  def is_killed_by?(weapon)
    weapon.damage > 3
  end

  def survive_attack_with(weapon)
    @life - weapon.damage
  end

end

class SoldierWithClassMembers
  def initialize
    @life = 10
  end
  def name
    "Tommy Boy"
  end
  def to_s
    "I'm a soldier"
  end
  def attack(target, weapon)
    weapon.attack(target)
  end
  def is_killed_by?(weapon)
    weapon.damage > 3
  end
  def survive_attack_with(weapon)
    @life - weapon.damage
  end
  def self.class_name
    "DaggerWithClassMembers"
  end
end

class Dagger

  def damage
    2
  end

  def attack(target)
    target.survive_attack_with self  
  end


end

class DaggerWithClassMembers
  def damage
    2
  end
  def attack(target)
    target.survive_attack_with self
  end
  def self.class_name
    "DaggerWithClassMembers"
  end
end

class WithClassMethods

  def hello_world
    "Hello World!"
  end

  def self.good_bye_world
    "Goodbye world!"
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

