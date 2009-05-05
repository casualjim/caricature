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

    before do
      @proxy = Caricature::ClrProxy.new(ClrModels::IWarrior)
    end

    it "should create a proxy" do
      @proxy.class.to_s.should.match /^IWarrior/
    end

    it "should create a method on the proxy" do
      @proxy.should.respond_to?(:is_killed_by)
    end

    it "should create a getter for a property on the proxy" do
      @proxy.should.respond_to?(:id)
    end

    it "should create a setter for a writable property on the proxy" do
      @proxy.should.respond_to?(:name=)
    end

  end

  describe "for a CLR Interface with an event" do

    before do
      @proxy = Caricature::ClrProxy.new(ClrModels::IExposing)
    end

    it "should create an add method for the event" do
      @proxy.should.respond_to?(:add_is_exposed_changed)
    end

    it "should create a remove method for the event" do
      @proxy.should.respond_to?(:remove_is_exposed_changed)
    end    

  end

  describe "for CLR interface recursion" do

    before do
      @proxy = Caricature::ClrProxy.new(ClrModels::IExposingWarrior)
    end

    it "should create a method defined on the CLR interface" do
      @proxy.should.respond_to?(:own_method)
    end

    it "should create a method defined on one of the composing interfaces" do
      @proxy.should.respond_to?(:some_method)
    end

    it "should create a method defined on one of the topmost composing interfaces" do
      @proxy.should.respond_to?(:is_killed_by)
    end

    it "should create an add method for an event defined on a composing interface" do
      @proxy.should.respond_to?(:add_is_exposed_changed)
    end

    it "should create a remove method for an event defined on a composing interface" do
      @proxy.should.respond_to?(:remove_is_exposed_changed)
    end

    it "should create a getter for a property on the proxy" do
      @proxy.should.respond_to?(:id)
    end

    it "should create a setter for a writable property on the proxy" do
      @proxy.should.respond_to?(:name=)
    end
  end

end