require File.dirname(__FILE__) + "/bacon_helper"

describe "Full scenarios" do

  it "should mock CLR interfaces successfully" do
    ninja = ClrModels::Ninja.new
    weapon = Caricature::Isolation.for(ClrModels::IWeapon)
    target = Caricature::Isolation.for(ClrModels::Ninja)

    ninja.attack ClrModels::Ninja.new, weapon

    weapon.was_told_to?(:attack).should.be.successful
  end

end