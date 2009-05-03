require File.dirname(__FILE__) + "/bacon_helper"
require File.dirname(__FILE__) + "/../lib/caricature/proxy"
require File.dirname(__FILE__) + "/../lib/core_ext"
load_assembly 'ClrModels'

class Soldier

  def name
    "Tommy Boy"
  end

  def to_s
    "I'm a soldier"
  end

end

describe "String" do

  it "should underscore a camel cased name" do
    "MockingAndStubbingForIronRuby1".underscore.should.equal "mocking_and_stubbing_for_iron_ruby1"
  end

end

describe "Caricature::SimpleProxy" do

  before do    
    @subj = Soldier.new
    @prxy = Caricature::SimpleProxy.new(@subj)
  end

  it "should forward existing methods" do
    @prxy.name.should.equal @subj.name
  end

  it "should call to_s on the proxied object" do
    @prxy.to_s.should.equal @subj.to_s    
  end
end

describe "Caricature::ClrProxy" do

  describe "for an instance of a CLR class" do

    it "should create a proxy" do
      samurai = ClrModels::Samurai.new
      samurai.name = "Nakiro"

      proxy = Caricature::ClrProxy.new(samurai)
      proxy.name.should.equal samurai.name
      proxy.id.should.equal 0
    end

  end

  describe "for a CLR class" do

    it "should create a proxy" do
      proxy = Caricature::ClrProxy.new(ClrModels::Ninja)
      proxy.subject.class.should.equal ClrModels::Ninja
      proxy.id.should.equal 0
    end

  end

  describe "for a CLR interface" do

    it "should create a proxy" do
      proxy = Caricature::ClrProxy.new(ClrModels::IWarrior)
      proxy.class.to_s.should.match /^IWarrior/        
    end

  end



end