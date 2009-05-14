require File.dirname(__FILE__) + "/bacon_helper"

describe "Full scenarios" do

  describe "when mocking CLR interfaces" do

    it "should work without expectations" do
      ninja = ClrModels::Ninja.new
      @weapon = Caricature::Isolation.for(ClrModels::IWeapon)
      ninja.attack ClrModels::Ninja.new, @weapon

      @weapon.was_told_to?(:attack).should.be.successful
    end

    it "should work with an expectation" do
      ninja = ClrModels::Ninja.new
      @weapon = Caricature::Isolation.for(ClrModels::IWeapon)
      @weapon.when_told_to(:damage).return(5)
      ninja.is_killed_by(@weapon).should.be.true?
      @weapon.was_told_to?(:damage).should.be.successful
    end

    it "should work with an expectation 2" do
      ninja = ClrModels::Ninja.new
      @weapon = Caricature::Isolation.for(ClrModels::IWeapon)
      @weapon.when_told_to(:damage).return(2)
      ninja.is_killed_by(@weapon).should.be.false?
      @weapon.was_told_to?(:damage).should.be.successful
    end

  end

end