
require 'rubygems'
# load the rspec library
require 'spec' unless defined? Spec

require File.dirname(__FILE__) + "/../spec_helper"


Spec::Runner.configure do |config|
  config.mock_with Caricature::RSpecAdapter
  config.include Caricature::RSpecMatchers
end
