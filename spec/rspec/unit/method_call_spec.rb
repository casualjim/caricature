require File.dirname(__FILE__) + "/../spec_helper"

describe "MethodCallRecorder" do

  before do
    @recorder = Caricature::MethodCallRecorder.new
  end

  describe "when recording a call without arguments" do

    before do
      @recorder.record_call :my_method
    end

    it "should have 1 method call" do
      @recorder.method_calls[:instance].size.should == 1
    end

    describe "recorded call" do

      before do
        @mc = @recorder.method_calls[:instance][:my_method]
      end

      it "should have a method call collected" do
        @mc.should_not be_nil
      end

      it "should have the correct name" do
        @mc.method_name.should == :my_method
      end

      it "should have no arguments" do
        @mc.args.should == [Caricature::ArgumentRecording.new]
      end

      it "should have no block" do
        @mc.block.should be_nil
      end

      it "should have a count a 1" do
        @mc.count.should == 1
      end

    end

  end

  describe "when recording a call without arguments but with a block" do

    before do
      @block_content = "I'm in the block"
      @recorder.record_call :my_method do
        @block_content
      end
    end

    it "should have 1 method call" do
      @recorder.method_calls[:instance].size.should == 1
    end

    describe "recorded call" do

      before do
        @mc = @recorder.method_calls[:instance][:my_method]
      end

      it "should have a method call collected" do
        @mc.should_not be_nil
      end

      it "should have the correct name" do
        @mc.method_name.should == :my_method
      end

      it "should have no arguments" do
        @mc.args.should == [Caricature::ArgumentRecording.new]
      end

      it "should have a block" do
        @mc.args.first.block.should_not be_nil
      end

      it "should have the correct block" do
        @mc.args.first.block.call.should == @block_content
      end

      it "should have a count a 1" do
        @mc.count.should == 1
      end

    end

  end

  describe "when recording a call 1 argument" do

    before do
      @recorder.record_call :my_method, :instance, nil, 1
    end

    it "should have 1 method call" do
      @recorder.method_calls[:instance].size.should == 1
    end

    describe "recorded call" do

      before do
        @mc = @recorder.method_calls[:instance][:my_method]
      end

      it "should have a method call collected" do
        @mc.should_not be_nil
      end

      it "should have the correct name" do
        @mc.method_name.should == :my_method
      end

      it "should have 1 argument" do
        @mc.args.size.should == 1
      end

      it "should have the correct argument" do
        @mc.args.should == [Caricature::ArgumentRecording.new([1])]
      end

      it "should have no block" do
        @mc.block.should be_nil
      end

      it "should have a count a 1" do
        @mc.count.should == 1
      end

    end

  end

  describe "when recording a call 2 arguments" do

    before do
      @recorder.record_call :my_method, :instance, nil, 1, 2
    end

    it "should have 1 method call" do
      @recorder.method_calls[:instance].size.should == 1
    end

    describe "recorded call" do

      before do
        @mc = @recorder.method_calls[:instance][:my_method]
      end

      it "should have a method call collected" do
        @mc.should_not be_nil
      end

      it "should have the correct name" do
        @mc.method_name.should == :my_method
      end

      it "should have 1 argument recording" do
        @mc.args.size.should == 1
      end

      it "should have the correct arguments" do
        @mc.args.should == [Caricature::ArgumentRecording.new([1, 2])]
      end

      it "should have no block" do
        @mc.block.should be_nil
      end

      it "should have a count a 1" do
        @mc.count.should == 1
      end

    end

  end

  describe "when recording 2 calls with no arguments" do

    before do
      @recorder.record_call :my_method
      @recorder.record_call :my_method
    end

    it "should have 1 method call" do
      @recorder.method_calls[:instance].size.should == 1
    end

    describe "recorded call" do

      before do
        @mc = @recorder.method_calls[:instance][:my_method]
      end

      it "should have a method call collected" do
        @mc.should_not be_nil
      end

      it "should have the correct name" do
        @mc.method_name.should == :my_method
      end

      it "should have no arguments" do
        @mc.args.should == [Caricature::ArgumentRecording.new]
      end

      it "should have no block" do
        @mc.block.should be_nil
      end

      it "should have a count of 2" do
        @mc.count.should == 2
      end

    end

  end

  describe "when recording a call with a block" do
    before do
      @args = []
      @b = @recorder.record_call :some_method, :instance, nil, 5, 6, 7 do |*args|
        @args = args
      end

    end

    it "should return a block" do
      @b.should_not be_nil
    end

    it "should return a block that wraps a recording" do
      @b.call 8, 9, 0
      @recorder.method_calls[:instance][:some_method].args.first.blocks.first.args.should == [8, 9, 0]
    end

    it "should call the original block" do
      @b.call 8, 9, 0
      @args.should == [8, 9, 0]
    end
  end

  describe "when recording 2 calls with different arguments" do

    before do
      @recorder.record_call :my_method
      @recorder.record_call :my_method, :instance, nil, 1, 3, 4
    end

    it "should have 1 method call" do
      @recorder.method_calls[:instance].size.should == 1
    end

    describe "recorded call" do

      before do
        @mc = @recorder.method_calls[:instance][:my_method]
      end

      it "should have a method call collected" do
        @mc.should_not be_nil
      end

      it "should have the correct name" do
        @mc.method_name.should == :my_method
      end

      it "should have argument variations" do
        @mc.has_argument_variations?.should be_true
      end

      it "should have no block" do
        @mc.block.should be_nil
      end

      it "should have a count of 2" do
        @mc.count.should == 2
      end

    end

  end

  describe "when asked if a certain method was called" do

    before do
      @recorder.record_call :my_method
      @recorder.record_call :my_method, :instance, nil, 1, 3, 4

    end

    it "should confirm when we don't care about the arguments" do
      @recorder.was_called?(:my_method, nil, :instance, :any).should be_true
    end

    it "should confirm when there are no argument variations" do
      @recorder.record_call :another_method
      @recorder.was_called?(:another_method, nil, :instance, :any).should be_true
    end

    it "should be negative when we provide the wrong arguments" do
      @recorder.was_called?(:my_method, nil, :instance, 1, 2, 5).should be_false
    end

    it "should be positive when we provide the correct arguments" do
      @recorder.was_called?(:my_method, nil, :instance, 1, 3, 4).should be_true
    end

    it "should be positive when we provide no arguments and a call had been recorded without arguments" do
      @recorder.was_called?(:my_method, nil, :instance).should be_true
    end

    describe "with block" do

      before do
        @args = []
        b = @recorder.record_call :some_method, :instance, nil, 5, 6, 7 do |*args|
          @args << args
        end
        b.call 1, 3, 5
        b.call 3, 4, 6
        b.call
      end

      it "should be positive when we provide any arguments" do
        @recorder.was_called?(:some_method, [:any], :instance, :any).should be_true
      end

      it "should be positive when we provide specific arguments" do
        @recorder.was_called?(:some_method, [1, 3, 5], :instance, :any).should be_true                
      end

    end

  end

end