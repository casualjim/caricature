require File.dirname(__FILE__) + "/../spec_helper"

describe "Caricature::TypeDescriptor" do

  before do
    @des = Caricature::TypeDescriptor.new :in_unit_test_for_class
  end

  it "should have a class_members method" do
    @des.should.respond_to?(:class_members)
  end

  it "should return an empty collection for the class members" do
    @des.class_members.should.be.empty
  end

  it "should have an instance members method" do
    @des.should.respond_to?(:instance_members)
  end

  it "should return an empty collection for the instance members" do
    @des.instance_members.should.be.empty
  end

  it "should raise a NotImplementedError for the initialize_instance_members method" do
    lambda { @des.initialize_instance_members_for Soldier }.should.raise NotImplementedError
  end

  it "should raise a NotImplementedError for the initialize_class_members method" do
    lambda { @des.initialize_class_members_for Soldier }.should.raise NotImplementedError
  end

end

describe "Caricature::MemberDescriptor" do

  it "should have a name" do
    des = Caricature::MemberDescriptor.new 'a name', 'a type'
    des.name.should.not.be.nil
  end

  it "should have the correct name" do
    des = Caricature::MemberDescriptor.new 'a name', 'a type'
    des.name.should.equal 'a name'
  end

  it "should have a return_type" do
    des = Caricature::MemberDescriptor.new 'a name', 'a type'
    des.return_type.should.not.be.nil
  end

  it "should have the correct return_type" do
    des = Caricature::MemberDescriptor.new 'a name', 'a type'
    des.return_type.should.equal 'a type'
  end

  it "should say it's an instance type" do
    des = Caricature::MemberDescriptor.new 'a name', 'a type'
    des.should.be.instance_member
  end

  it "should say it's not an instance type" do
    des = Caricature::MemberDescriptor.new 'a name', 'a type', false
    des.should.not.be.instance_member
  end

end

describe Caricature::ClrEventDescriptor.to_s do

  it "should have an event name" do
    des = Caricature::ClrEventDescriptor.new "EventName"
    des.event_name.should == "EventName"
  end

  it "should correctly identify when it's not an instance member" do
    des = Caricature::ClrEventDescriptor.new "EventName", false
    des.should.not.be.instance_member
  end

end

describe "Caricature::ClrInterfaceDescriptor" do

  describe "when collecting methods" do

    before do
      @des = Caricature::ClrInterfaceDescriptor.new ClrModels::IWeapon
    end

    it "should have 2 instance members" do
      @des.instance_members.size.should.equal 2
    end

    it "should contain only instance members" do
      result = true
      @des.instance_members.each do |mem|
        result = false unless mem.instance_member?
      end

      result.should.be.true
    end

    it "should have a damage instance member" do
      @des.instance_members.select { |mem| mem.name == "damage" }.should.not.be.empty
    end

    it "should correctly identify indexers" do
      des = Caricature::ClrInterfaceDescriptor.new ClrModels::IHaveAnIndexer
      des.instance_members.select { |mem| mem.name == "__getitem__" }.should.not.be.empty
    end

    it "should correctly identify indexers" do
      des = Caricature::ClrInterfaceDescriptor.new ClrModels::IHaveAnIndexer
      des.instance_members.select { |mem| mem.name == "__setitem__" }.should.not.be.empty
    end
  end

  describe "when collecting events" do

    before do
      @des = Caricature::ClrInterfaceDescriptor.new ClrModels::IExplodingWarrior
    end

    it "should have collected 2 events" do
      @des.events.size.should == 2
    end

    it "should have collected 2 instance events" do
      @des.events.all? { |ev| ev.instance_member? }.should.be.true?
    end


  end

end

describe "Caricature::ClrClassDescriptor" do

  describe "when collecting methods" do

    before do
      @des = Caricature::ClrClassDescriptor.new ClrModels::SwordWithStatics
    end

    it "should have 11 instance members" do
      @des.instance_members.size.should.equal 11
    end

    it "should have 5 static members" do
      @des.class_members.size.should.equal 5
    end

    it "should have a damage instance member" do
      @des.instance_members.select { |mem| mem.name == "damage" }.should.not.be.empty
    end

    it "should have a another method instance member" do
      @des.instance_members.select { |mem| mem.name == "another_method" }.should.not.be.empty
    end

    it "should correctly identify indexers" do
      des = Caricature::ClrClassDescriptor.new ClrModels::IndexerContained
      des.instance_members.select { |mem| mem.name == "__getitem__" }.should.not.be.empty
    end

    it "should correctly identify indexers" do
      des = Caricature::ClrClassDescriptor.new ClrModels::IndexerContained
      des.instance_members.select { |mem| mem.name == "__setitem__" }.should.not.be.empty
    end
  end

  describe "when collecting events" do

    before do
      @des = Caricature::ClrClassDescriptor.new ClrModels::ExposingWarrior
    end

    it "should have 2 instance events" do
      @des.events.size.should == 2
    end

    it "should should have 1 class event" do
      @des.class_events.size.should == 1
    end

  end

end

describe "Caricature::RubyObjectDescriptor" do

  before do
    @des = Caricature::RubyObjectDescriptor.new DaggerWithClassMembers
  end

  it "should have 2 instance members" do
    @des.instance_members.size.should.equal 2
  end

  it "should have a damage instance member" do
    @des.instance_members.select { |mem| mem.name == "damage" }.should.not.be.empty
  end

  it "should have 1 class member" do
    @des.class_members.size.should.equal 1
  end

  it "should have a class_name class member" do
    @des.class_members.select { |mem| mem.name == "class_name" }.should.not.be.empty
  end

end