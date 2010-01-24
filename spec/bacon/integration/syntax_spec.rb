require File.dirname(__FILE__) + "/../spec_helper"

describe "syntax improvements" do

  describe "creation from a class method" do

    it "should allow creating an isolation" do
      soldier = Soldier.isolate
      soldier.should.not.be.nil
    end

    it "should allow setting an expectation" do
      soldier = SoldierWithClassMembers.isolate(:class_name){ |exp| exp.return("overridden") }
      soldier.class.class_name.should == "overridden"
    end

  end


  describe "creation from an instance method" do

    it "should allow creating an isolation" do
      soldier = Soldier.new.isolate
      soldier.should.not.be.nil
    end

    it "should allow setting an expectation" do
      soldier = Soldier.new.isolate(:name){ |exp| exp.return("overridden") }
      soldier.name.should == "overridden"
    end

  end
end