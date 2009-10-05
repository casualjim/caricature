require File.dirname(__FILE__) + "/../spec_helper"

describe "CLR event handling" do

  describe "for CLR interfaces" do

    before do
      @proxy = isolate ClrModels::IExplodingWarrior
    end

    it "should not raise an error when subcribing to an event" do
      lambda { ClrModels::ExposedChangedSubscriber.new(@proxy) }.should.not.raise
    end

#    it "should have 1 event subscription" do
#
#    end

  end

end