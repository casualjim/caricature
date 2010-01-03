require File.dirname(__FILE__) + "/../spec_helper"

describe "String" do

  it "should underscore a camel cased name" do
    "MockingAndStubbingForIronRuby1".underscore.should == "mocking_and_stubbing_for_iron_ruby1"
  end

  it "should get the class if it exists" do
    "String".classify.should == String
  end

end

describe "Module" do

  it "should strip the module names" do
    ClrModels::IExposingWarrior.demodulize.should == "IExposingWarrior"
  end

  it "should identify it's not a CLR type for a Ruby defined module" do
    Caricature.should_not be_clr_type
  end

  it "should identify it's a CLR type for a CLR defined interface" do
    ClrModels::IExposingWarrior.should be_clr_type
  end

  it "should identify it's a CLR type for a Ruby defined module that includes a CLR interface" do
    Caricature::InterfaceIncludingModule.should be_clr_type
  end

  it "should identify it's not a CLR type for a Ruby defined module that includes a Ruby module" do
    Caricature::RubyModuleIncludingModule.should_not be_clr_type
  end

  it "should identify it's a CLR type when an ancestor includes a CLR interface" do
    Caricature::InterfaceUpTheWazoo.should be_clr_type
  end

end

describe "Class" do

  it "should strip the module names" do
    ClrModels::Ninja.demodulize.should == "Ninja"
  end

  it "should identify it's not a CLR type for a ruby defined type" do
    Soldier.should_not be_clr_type
  end

  it "should identify it's not a CLR type for a ruby defined type that subclasses a Ruby class" do
    Caricature::SubclassingRubyClass.should_not be_clr_type
  end

  it "should identify it's not a CLR type for a ruby defined type that includes only ruby modueles in its hierarchy" do
    Caricature::ModuleIncludingClass.should_not be_clr_type
  end

  it "should identify it's a CLR type for a type defined in C#" do
    ClrModels::Ninja.should be_clr_type
  end

  it "should identify it's a CLR type for a type defined in Ruby that includes a CLR interface" do
    Caricature::InterfaceIncludingClass.should be_clr_type
  end

  it "should identify it's a CLR type for a type defined in Ruby that subclasses a CLR class" do
    Caricature::SubClassingClrClass.should be_clr_type
  end

  it "should identify it's a CLR type for a type defined in Ruby that includes a CLR interface in its hierarchy" do
    Caricature::InterfaceUpTheWazooClass.should be_clr_type
  end

end

describe "Array" do

  it "should convert an array to a hash" do
    expected = { :key1 => "value1", :key2 => "value2"}
    %w(key1 value1 key2 value2).to_h.should == expected
  end

end

