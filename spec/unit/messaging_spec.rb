require File.dirname(__FILE__) + "/../bacon_helper"

class EmptyExpectations

  def find(method_name, *args, &b)
    nil
  end
end

class ReturnValueExpecation

  def initialize
    @super_before_called = false
    @call_super_called = false
    @called_super_after = false
  end

  def block
    nil
  end

  def super_before?
    @super_before_called = true
    false
  end

  def call_super?
    @call_super_called = true
    false
  end

  def have_called_super_before?
    @super_before_called
  end

  def have_called_call_super?
    @super_before_called && @called_super_after
  end

  def execute(*args)
    @called_super_after = !@call_super_called
    5
  end
end

class ReturnValueExpectations

  def expectation
    @expectation ||= ReturnValueExpecation.new
    @expectation
  end
  def find(method_name, *args, &b)
    return expectation  if method_name == :a_message
    nil
  end
end

class PassThruBlockExpectation

  def block
    nil
  end

  def block_args
    [5,6,7]
  end

  def execute(*args, &b)
    b.call *block_args
  end

  def super_before?
    false
  end

  def call_super?
    false
  end

end

class CallingBlock
  def a_message(*args, &b)
    b.call(7,8,9)
  end
end

class BlockExpectation
  def block
    lambda { |*args| return args }
  end

  def super_before?
    false
  end

  def call_super?
    true
  end

  def execute(*args, &b)

  end

end

class BlockExpectations

  def initialize(pass_thru=true)
    @pass_thru = pass_thru
  end

  def expectation
    @expectation ||= (@pass_thru ? PassThruBlockExpectation.new : BlockExpectation.new)
    @expectation
  end
  def find(method_name, *args, &b)
    return expectation  if method_name == :a_message
    nil
  end
end


describe "Caricature::Messenger strategies" do

  describe "Caricature::RubyMessenger" do

    it "should return nil for any method name not in the expectation collection" do
      messenger = Caricature::RubyMessenger.new EmptyExpectations.new
      messenger.deliver(:a_message, nil).should.be.nil
    end

    describe "when an expectation with a return value has been defined" do

      before do
        @messenger = Caricature::RubyMessenger.new ReturnValueExpectations.new
      end

      it "should return the a value when specified by the expecation" do
        @messenger.deliver(:a_message, nil).should.not.be.nil
      end

      it "should return the value specified by the expecation" do
        @messenger.deliver(:a_message, nil).should.equal 5
      end

      it "should call super_before before executing the expectation" do
        @messenger.deliver(:a_message, nil)
        @messenger.expectations.expectation.should.have_called_super_before
      end

      it "should call call_super? after executing the expectation" do
        @messenger.deliver(:a_message, nil)
        @messenger.expectations.expectation.should.have_called_call_super
      end

    end

    describe "when an expectation with a block has been defined" do

      it "should invoke the block that is passed with the args from the expectation only once"  do
        messenger = Caricature::RubyMessenger.new BlockExpectations.new
        counter = 0
        arguments = []
        messenger.deliver(:a_message, nil) do |*args|
          counter += 1
          arguments = args
        end
        counter.should == 1
        [5,6,7].should == arguments
      end

      it "should call the block that is defined on the expectation by super when call super is enabled" do
        messenger = Caricature::RubyMessenger.new BlockExpectations.new(false), CallingBlock.new
        result = messenger.deliver(:a_message, nil)
        [7,8,9].should == result
      end

    end


  end

  describe "Caricature::ClrClassMessenger" do

    it "should return nil for any method name not in the expectation collection" do
      messenger = Caricature::ClrClassMessenger.new EmptyExpectations.new
      messenger.deliver(:a_message, nil).should.be.nil
    end

    it "should return the default value for a value type return type" do
      messenger = Caricature::ClrClassMessenger.new EmptyExpectations.new
      messenger.deliver(:a_message, System::Int32.to_clr_type).should.equal 0
    end

    describe "when an expectation with a return value has been defined" do

      before do
        @messenger = Caricature::ClrClassMessenger.new ReturnValueExpectations.new
      end

      it "should return the a value when specified by the expecation" do
        @messenger.deliver(:a_message, nil).should.not.be.nil
      end

      it "should return the value specified by the expecation" do
        @messenger.deliver(:a_message, nil).should.equal 5
      end

      it "should call super_before before executing the expectation" do
        @messenger.deliver(:a_message, nil)
        @messenger.expectations.expectation.should.have_called_super_before
      end

      it "should call call_super? after executing the expectation" do
        @messenger.deliver(:a_message, nil)
        @messenger.expectations.expectation.should.have_called_call_super
      end

    end

    describe "when an expectation with a block has been defined" do

      it "should invoke the block that is passed with the args from the expectation only once"  do
        messenger = Caricature::ClrClassMessenger.new BlockExpectations.new
        counter = 0
        arguments = []
        messenger.deliver(:a_message, nil) do |*args|
          counter += 1
          arguments = args
        end
        counter.should == 1
        [5,6,7].should == arguments
      end

      it "should call the block that is defined on the expectation by super when call super is enabled" do
        messenger = Caricature::ClrClassMessenger.new BlockExpectations.new(false), CallingBlock.new
        result = messenger.deliver(:a_message, nil)
        [7,8,9].should == result
      end

    end

  end

  describe "Caricature::ClrInterfaceMessenger" do

    it "should return nil for any method name not in the expectation collection" do
      messenger = Caricature::ClrInterfaceMessenger.new EmptyExpectations.new
      messenger.deliver(:a_message, nil).should.be.nil
    end

    it "should return the default value for a value type return type" do
      messenger = Caricature::ClrClassMessenger.new EmptyExpectations.new
      messenger.deliver(:a_message, System::Int32.to_clr_type).should.equal 0
    end

    describe "when an expectation with a return value has been defined" do

      before do
        @messenger = Caricature::ClrInterfaceMessenger.new ReturnValueExpectations.new
      end

      it "should return the a value when specified by the expecation" do
        @messenger.deliver(:a_message, nil).should.not.be.nil
      end

      it "should return the value specified by the expecation" do
        @messenger.deliver(:a_message, nil).should.equal 5
      end

      it "should not call super_before before executing the expectation" do
        @messenger.deliver(:a_message, nil)
        @messenger.expectations.expectation.should.not.have_called_super_before
      end

      it "should not call call_super? after executing the expectation" do
        @messenger.deliver(:a_message, nil)
        @messenger.expectations.expectation.should.not.have_called_call_super
      end

    end

    describe "when an expectation with a block has been defined" do

      it "should invoke the block that is passed with the args from the expectation only once"  do
        messenger = Caricature::ClrInterfaceMessenger.new BlockExpectations.new
        counter = 0
        arguments = []
        messenger.deliver(:a_message, nil) do |*args|
          counter += 1
          arguments = args
        end
        counter.should == 1
        [5,6,7].should == arguments
      end

    end

  end

end