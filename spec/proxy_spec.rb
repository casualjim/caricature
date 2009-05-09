require File.dirname(__FILE__) + "/bacon_helper"

describe "Caricature::RecordingProxy" do

  before do    
    @subj = Soldier.new
    @recorder = Caricature::MethodCallRecorder.new
    @proxy = Caricature::RecordingProxy.new(@subj, @recorder)
  end

  it "should forward existing methods" do
    @proxy.name.should.equal @subj.name
  end

  it "should call to_s on the proxied object" do
    @proxy.to_s.should.equal @subj.to_s
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

describe "Caricature::RecordingClrProxy" do

  describe "for an instance of a CLR class" do

    before do
      @samurai = ClrModels::Samurai.new
      @samurai.name = "Nakiro"
      @recorder = Caricature::MethodCallRecorder.new
      @proxy = Caricature::RecordingClrProxy.new(@samurai, @recorder)
    end

    it "should create a proxy" do

      @proxy.name.should.equal @samurai.name
      @proxy.id.should.equal 0
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

  describe "for a CLR class" do

    before do
      @recorder = Caricature::MethodCallRecorder.new
      @proxy = Caricature::RecordingClrProxy.new(ClrModels::Ninja, @recorder)
    end

    it "should create a proxy" do
      @proxy.___subject___.class.should.equal ClrModels::Ninja
      @proxy.id.should.equal 0
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
      @proxy = Caricature::RecordingClrProxy.new(ClrModels::IWarrior, @recorder)
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
      @proxy = Caricature::RecordingClrProxy.new(ClrModels::IExposing, @recorder)
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
      @proxy = Caricature::RecordingClrProxy.new(ClrModels::IExposingWarrior, Caricature::MethodCallRecorder.new)
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