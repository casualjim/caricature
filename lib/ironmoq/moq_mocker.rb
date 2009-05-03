load_assembly 'Moq'

class MoqMocker

  # the object that contains the mock
  attr_reader :mock

  def initialize(obj, &block)
    @mock = Moq::MockObject.of(obj).new
  end

  # the mocked object
  def obj
    @mock.object
  end
end