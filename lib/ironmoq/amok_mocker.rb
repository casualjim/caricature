require File.dirname(__FILE__) + "/../../vendor/amok/amok"

class AmokMocker

  # the object that contains the mock
  attr_reader :mock

  def initialize(obj, &block)
    @mock = Amok.new(obj, &block)
  end

  # the mocked object
  def obj
    @mock.obj
  end
end