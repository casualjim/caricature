require File.dirname(__FILE__) + "/../spec_helper"

describe "String" do

  it "should underscore a camel cased name" do
    "MockingAndStubbingForIronRuby1".underscore.should.equal "mocking_and_stubbing_for_iron_ruby1"
  end

  it "should get the class if it exists" do
    "String".classify.should.equal String
  end

end

describe "Module" do

  it "should strip the module names" do
    ClrModels::IExposingWarrior.demodulize.should.equal "IExposingWarrior"
  end

  it "should identify it's not a CLR type for a Ruby defined module" do
    Caricature.is_clr_type?.should.be.false?
  end

  it "should identify it's a CLR type for a CLR defined interface" do
    ClrModels::IExposingWarrior.is_clr_type?.should.be.true?
  end

  it "should identify it's a CLR type for a Ruby defined module that includes a CLR interface" do
    Caricature::InterfaceIncludingModule.is_clr_type?.should.be.true?
  end

  it "should identify it's not a CLR type for a Ruby defined module that includes a Ruby module" do
    Caricature::RubyModuleIncludingModule.is_clr_type?.should.be.false?
  end

  it "should identify it's a CLR type when an ancestor includes a CLR interface" do
    Caricature::InterfaceUpTheWazoo.is_clr_type?.should.be.true?
  end

end

describe "Class" do

  it "should strip the module names" do
    ClrModels::Ninja.demodulize.should.equal "Ninja"
  end

  it "should identify it's not a CLR type for a ruby defined type" do
    Soldier.is_clr_type?.should.be.false?
  end

  it "should identify it's not a CLR type for a ruby defined type that subclasses a Ruby class" do
    Caricature::SubclassingRubyClass.is_clr_type?.should.be.false?
  end

  it "should identify it's not a CLR type for a ruby defined type that includes only ruby modueles in its hierarchy" do
    Caricature::ModuleIncludingClass.is_clr_type?.should.be.false?
  end

  it "should identify it's a CLR type for a type defined in C#" do
    ClrModels::Ninja.is_clr_type?.should.be.true?
  end

  it "should identify it's a CLR type for a type defined in Ruby that includes a CLR interface" do
    Caricature::InterfaceIncludingClass.is_clr_type?.should.be.true?
  end

  it "should identify it's a CLR type for a type defined in Ruby that subclasses a CLR class" do
    Caricature::SubClassingClrClass.is_clr_type?.should.be.true?
  end

  it "should identify it's a CLR type for a type defined in Ruby that includes a CLR interface in its hierarchy" do
    Caricature::InterfaceUpTheWazooClass.is_clr_type?.should.be.true?
  end

end

describe "Array" do

  it "should convert an array to a hash" do
    expected = { :key1 => "value1", :key2 => "value2"}
    %w(key1 value1 key2 value2).to_h.should.equal expected
  end

end

