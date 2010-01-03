require 'rubygems' unless defined?(Gem)
$:.unshift File.dirname(__FILE__)
require 'uuidtools'

module Caricature
#
#  module Interception
#
#  end
#
end

require 'caricature/core_ext'   
require 'caricature/version'
require 'caricature/isolation'     
require 'caricature/clr' if defined? IRONRUBY_VERSION 
require 'caricature/bacon' if defined? Bacon
require 'caricature/rspec' if defined? Spec

# convenience method for creating an isolation. aliased as mock and stub for less surprises
def isolate(subject, recorder = Caricature::MethodCallRecorder.new, expectations = Caricature::Expectations.new)
  Caricature::Isolation.for(subject, recorder, expectations)
end
alias :mock :isolate
alias :stub :isolate
