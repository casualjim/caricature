require File.dirname(__FILE__) + "/../spec_helper"

describe "CLR event handling" do

  context "for CLR interfaces" do

    before do
      @proxy = isolate ClrModels::IExplodingWarrior
    end

    it "should not raise an error when subcribing to an event" do
      lambda { ClrModels::ExposedChangedSubscriber.new(@proxy) }.should_not raise_error
    end  

  end

end