require File.dirname(__FILE__) + "/../bacon_helper.rb"
load_assembly 'ClrModels'
require File.dirname(__FILE__) + "/../../lib/ironmoq/moq_mocker"

describe "MoqMocker" do

  describe "initialization" do

    it "should create a mock of an interface" do
      mock = MoqMocker.new(ClrModels::IWeapon)
      mock.nil?.should.be.false?
    end

  end
end