# add some search paths to ironruby
# this first one adds the path with the assemblies
# this enables us not to have to specify a path to the assemblies everywhere.
$: << File.dirname(__FILE__) + "/bin"
# adds the path to the caricature library.
$: << File.dirname(__FILE__) + "/../lib"

# load the caricature library
require "caricature"

# load the assembly with the C# code
require 'ClrModels.dll' if defined? IRONRUBY_VERSION

# Load the ruby models
require File.dirname(__FILE__) + "/fixtures/soldier"
Dir[File.dirname(__FILE__) + "/fixtures/*.rb"].each { |l| require l }