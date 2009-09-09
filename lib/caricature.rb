$:.unshift File.dirname(__FILE__)

module Caricature
#
#  module Interception
#
#  end
#
end

require 'core_ext/core_ext'   
require 'caricature/version'
require 'caricature/isolation'     
require 'caricature/clr' if defined? IRONRUBY_VERSION  
