require File.dirname(__FILE__) + "/../spec_helper.rb"

class ClrModels::Sword

  def to_s
    "<ClrModels::Sword object_id: #{object_id} >"
  end
  alias_method :inspect, :to_s

end

describe "ClrModels::Sword" do

  before do
    @warrior = Caricature::Isolation.for ClrModels::IWarrior
  end

  it "should call survive_attack on the mock" do
    @warrior.when_receiving(:survive_attack_with).return(5)

    sword = ClrModels::Sword.new
    sword.attack(@warrior).should == 5

    @warrior.did_receive?(:survive_attack_with).should be_successful
  end

  it "should return different results when expectation is defined with arguments" do
    sword1 = ClrModels::Sword.new
    sword2 = ClrModels::Sword.new

    @warrior.when_receiving(:survive_attack_with).with(:any).return(5)
    @warrior.when_receiving(:survive_attack_with).with(sword2).return(15)

    sword1.attack(@warrior).should == 5
    sword2.attack(@warrior).should == 15

    @warrior.did_receive?(:survive_attack_with).with(sword2).should be_successful
  end

end