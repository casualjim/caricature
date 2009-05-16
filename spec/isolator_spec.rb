require File.dirname(__FILE__) + "/bacon_helper"

describe "Caricature::RubyIsolator" do

  before do    
    @subj = Soldier.new
    @recorder = Caricature::MethodCallRecorder.new
    context = Caricature::IsolationContext.new(@subj, @recorder)
    @proxy = Caricature::RubyIsolator.isolate context
  end

  
  describe "when invoking a method" do

    before do
      @proxy.name
    end

    it "should return nil" do
      @proxy.name.should.be.nil
    end

    it "should record a call" do
      @recorder.size.should.equal 1
    end

    it "should record the correct call" do
      mc = @recorder[:name]
      mc.method_name.should.equal :name
      mc.args.should.equal [Caricature::ArgumentRecording.new]
      mc.block.should.equal nil
    end

  end
end

describe "Caricature::RecordingClrProxy" do

  describe "for an instance of a CLR class" do

    before do
      @ninja = ClrModels::Ninja.new
      @ninja.name = "Nakiro"
      @recorder = Caricature::MethodCallRecorder.new
      context = Caricature::IsolationContext.new(@ninja, @recorder)
      @proxy = Caricature::ClrIsolator.isolate context
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

      it "should record a call" do
        @recorder.size.should.equal 1
      end

      it "should record the correct call" do
        mc = @recorder[:name]
        mc.method_name.should.equal :name
        mc.args.should.equal [Caricature::ArgumentRecording.new]
        mc.block.should.equal nil
      end

    end

  end

  describe "for a CLR class" do

    before do
      @recorder = Caricature::MethodCallRecorder.new
      context = Caricature::IsolationContext.new(ClrModels::Ninja, @recorder)
      @proxy = Caricature::ClrIsolator.isolate context
    end

    it "should create a proxy" do
      
      @proxy.___super___.class.should.equal ClrModels::Ninja
      
    end


    describe "when invoking a method" do

      before do
        @proxy.name
      end

      it "should record a call" do
        @recorder.size.should.equal 1
      end

      it "should record the correct call" do
        mc = @recorder[:name]
        mc.method_name.should.equal :name
        mc.args.should.equal [Caricature::ArgumentRecording.new]
        mc.block.should.equal nil
      end

    end
  end

  describe "for a CLR interface" do

    before do
      @recorder = Caricature::MethodCallRecorder.new
      context = Caricature::IsolationContext.new(ClrModels::IWarrior, @recorder)
      @proxy = Caricature::ClrInterfaceIsolator.isolate context
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

    describe "when invoking a method" do

      before do
        @proxy.name
      end

      it "should record a call" do
        @recorder.size.should.equal 1
      end

      it "should record the correct call" do
        mc = @recorder[:name]
        mc.method_name.should.equal :name
        mc.args.should.equal [Caricature::ArgumentRecording.new]
        mc.block.should.equal nil
      end

    end

  end

  describe "for a CLR Interface with an event" do

    before do
      @recorder = Caricature::MethodCallRecorder.new
      context = Caricature::IsolationContext.new(ClrModels::IExposing, @recorder)
      @proxy = Caricature::ClrInterfaceIsolator.isolate context
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
      context = Caricature::IsolationContext.new(ClrModels::IExposingWarrior, Caricature::MethodCallRecorder.new)
      @proxy = Caricature::ClrInterfaceIsolator.isolate context
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