#$: << File.dirname(__FILE__) + '/../lib/bin'
$: << File.dirname(__FILE__) + "/bin"
require 'bacon'
require 'mscorlib'
#require File.dirname(__FILE__) + "/../lib/ironmoq.rb"
require File.dirname(__FILE__) + "/../lib/caricature"
require File.dirname(__FILE__) + "/../lib/core_ext"
load_assembly 'ClrModels'
