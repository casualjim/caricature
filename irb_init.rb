#require File.dirname(__FILE__) + "/spec/bin/ClrModels.dll"
require File.dirname(__FILE__) + "/lib/caricature.rb"
#require File.dirname(__FILE__) + "/lib/caricature/clr.rb"

class MyClass; def initialize; puts "in initialize"; end; def self.new; puts "in new"; super; end; end

w = Caricature::Isolation.for(MyClass)    
puts w.class
#w.when_receiving(:damage).return(5)
puts w
#puts w.damage

