require File.dirname(__FILE__) + "/../spec_helper"

class TestIsolation
  attr_accessor :instance, :expectations
  def initialize(instance, expectations)
    @instance, @expectations = instance, expectations
  end
  def send_message(method_name, return_type, *args, &b)
    internal_send method_name, :internal, return_type, *args, &b
  end
  def send_class_message(method_name, return_type, *args, &b)
    internal_send method_name, :class, return_type, *args, &b
  end
  def internal_send(method_name, mode, return_type, *args, &b)
    exp = expectations.find(method_name, mode, *args)
    if exp
      res = instance.__send__(method_name, *args, &b) if exp.super_before?
      res = exp.execute(*args)
      res = instance.__send__(method_name, *args, &b) if !exp.super_before? and exp.call_super?
      res
    else
      rt = nil
      is_value_type = return_type && return_type != System::Void.to_clr_type && return_type.is_value_type
      rt = System::Activator.create_instance(return_type) if is_value_type
      rt
    end
  end
end

describe "Caricature::RubyIsolator" do

  before do    
    @subj = Soldier.new
    res = Caricature::RubyIsolator.for Caricature::IsolatorContext.new(@subj)
    iso = TestIsolation.new res.subject, Caricature::Expectations.new
    @proxy = res.isolation
    @proxy.class.instance_variable_set("@___context___", iso)
  end

  
  describe "when invoking a method" do

    before do
      @proxy.name
    end

    it "should return nil" do
      @proxy.name.should.be.nil
    end

  end

  describe "when isolating a class with class members" do

    before do
      res = Caricature::RubyIsolator.for Caricature::IsolatorContext.new(DaggerWithClassMembers)
      iso = TestIsolation.new res.subject, Caricature::Expectations.new
      @proxy = res.isolation
      @proxy.class.instance_variable_set("@___context___", iso)
    end

    it "should return nil for the class method" do

      @proxy.class.class_name.should.be.nil

    end

  end
end

describe "Caricature::RecordingClrProxy" do

  describe "for an instance of a CLR class" do

    before do
      @ninja = ClrModels::Ninja.new
      @ninja.name = "Nakiro"
      context = Caricature::IsolatorContext.new(@ninja)
      res = Caricature::ClrIsolator.for context
      iso = TestIsolation.new res.subject, Caricature::Expectations.new
      @proxy = res.isolation
      @proxy.class.instance_variable_set("@___context___", iso)
    end

    it "should create a proxy" do

      @proxy.___super___.name.should.equal @ninja.name
      @proxy.___super___.id.should.equal 1
    end

    describe "when invoking a method" do

      before do
        @proxy.name
      end

      it "should return nil" do
        @proxy.name.should.be.nil
      end

    end

    describe "when isolating a class with class members" do

      before do
        res = Caricature::ClrIsolator.for Caricature::IsolatorContext.new(ClrModels::SwordWithStatics)
        iso = TestIsolation.new res.subject, Caricature::Expectations.new
        @proxy = res.isolation
        @proxy.class.instance_variable_set("@___context___", iso)
      end

      it "should return nil for the class method" do

        @proxy.class.class_naming.should.be.nil

      end

    end

  end

  describe "for a CLR class" do

    before do
      @recorder = Caricature::MethodCallRecorder.new
      context = Caricature::IsolatorContext.new(ClrModels::Ninja, @recorder)
      res = Caricature::ClrIsolator.for context
      iso = TestIsolation.new res.subject, Caricature::Expectations.new
      @proxy = res.isolation
      @proxy.class.instance_variable_set("@___context___", iso)
    end

    it "should create a proxy" do
      
      @proxy.class.superclass.should.equal ClrModels::Ninja
      
    end


  end

  describe "for a CLR interface" do

    before do
      res = Caricature::ClrInterfaceIsolator.for Caricature::IsolatorContext.new(ClrModels::IWarrior)
      @proxy = res.isolation
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
      res = Caricature::ClrInterfaceIsolator.for Caricature::IsolatorContext.new(ClrModels::IExposing)
      @proxy = res.isolation
    end

    it "should create an add method for the event" do
      @proxy.should.respond_to?(:add_on_is_exposed_changed)
    end

    it "should create a remove method for the event" do
      @proxy.should.respond_to?(:remove_on_is_exposed_changed)
    end

  end

  describe "for CLR interface recursion" do

    before do
      res = Caricature::ClrInterfaceIsolator.for Caricature::IsolatorContext.new(ClrModels::IExposingWarrior)
      @proxy = res.isolation
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
      @proxy.should.respond_to?(:add_on_is_exposed_changed)
    end

    it "should create a remove method for an event defined on a composing interface" do
      @proxy.should.respond_to?(:remove_on_is_exposed_changed)
    end

    it "should create a getter for a property on the proxy" do
      @proxy.should.respond_to?(:id)
    end

    it "should create a setter for a writable property on the proxy" do
      @proxy.should.respond_to?(:name=)
    end
  end

end