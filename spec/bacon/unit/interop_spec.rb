require File.dirname(__FILE__) + "/../spec_helper"

describe "Event handling" do



  describe "for precompiled CLR classes" do

    before do
      @warrior = ClrModels::ExposingWarrior.new
    end

    it "should subscribe to an event" do
      ClrModels::ExposedChangedSubscriber.new(@warrior)
      @warrior.has_event_subscriptions.should.be.true?
    end

    it "should not raise an error when subcribing to an event" do
      lambda { ClrModels::ExposedChangedSubscriber.new(@warrior) }.should.not.raise
    end

    it "should handle an event when raised" do
      subscriber = ClrModels::ExposedChangedSubscriber.new(@warrior)
      @warrior.change_is_exposed
      subscriber.counter.should.equal 1
    end

  end 

end