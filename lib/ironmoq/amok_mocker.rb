require File.dirname(__FILE__) + "/../../vendor/amok/amok"
require 'forwardable'

# A facade over the Amok mocking framework
# at this point it's just forwarding methods but that may change
class AmokMocker

  extend Forwardable

  # the object that contains the mock
  attr_reader :mock

  def initialize(obj, &block)
    @mock = Amok.new(obj, &block)
  end

  def_delegators :@mock, :obj, :on, :previous, :need, :never, :errors, :successful?, :validate, :cleanup!

end