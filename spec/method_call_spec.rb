require File.dirname(__FILE__) + "/bacon_helper"

describe "MethodCallRecorder" do

  before do
    @recorder = Caricature::MethodCallRecorder.new
  end

  describe "when recording a call without arguments" do

    before do
      @recorder.record_call :my_method
    end

    it "should have 1 method call" do
      @recorder.method_calls.size.should.equal 1
    end

    describe "recorded call" do

      before do
        @mc = @recorder.method_calls[:my_method]
      end

      it "should have a method call collected" do
        @mc.should.not.equal nil
      end

      it "should have the correct name" do
        @mc.method_name.should.equal :my_method
      end

      it "should have no arguments" do
        @mc.args.should.equal [Caricature::ArgumentRecording.new]
      end

      it "should have no block" do
         @mc.block.should.equal nil
      end

      it "should have a count a 1" do
        @mc.count.should.equal 1
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
      @recorder.method_calls.size.should.equal 1
    end

    describe "recorded call" do

      before do
        @mc = @recorder.method_calls[:my_method]
      end

      it "should have a method call collected" do
        @mc.should.not.equal nil
      end

      it "should have the correct name" do
        @mc.method_name.should.equal :my_method
      end

      it "should have no arguments" do
        @mc.args.should.equal [Caricature::ArgumentRecording.new]
      end

      it "should have a block" do
         @mc.args.first.block.should.not.equal nil
      end

      it "should have the correct block" do
        @mc.args.first.block.call.should.equal @block_content
      end

      it "should have a count a 1" do
        @mc.count.should.equal 1
      end

    end

  end

  describe "when recording a call 1 argument" do

    before do
      @recorder.record_call :my_method, 1
    end

    it "should have 1 method call" do
      @recorder.method_calls.size.should.equal 1
    end

    describe "recorded call" do

      before do
        @mc = @recorder.method_calls[:my_method]
      end

      it "should have a method call collected" do
        @mc.should.not.equal nil
      end

      it "should have the correct name" do
        @mc.method_name.should.equal :my_method
      end

      it "should have 1 argument" do
        @mc.args.size.should.equal 1
      end

      it "should have the correct argument" do
        @mc.args.should.equal [Caricature::ArgumentRecording.new([1])]
      end

      it "should have no block" do
         @mc.block.should.equal nil
      end

      it "should have a count a 1" do
        @mc.count.should.equal 1
      end

    end

  end

  describe "when recording a call 2 arguments" do

    before do
      @recorder.record_call :my_method, 1, 2
    end

    it "should have 1 method call" do
      @recorder.method_calls.size.should.equal 1
    end

    describe "recorded call" do

      before do
        @mc = @recorder.method_calls[:my_method]
      end

      it "should have a method call collected" do
        @mc.should.not.equal nil
      end

      it "should have the correct name" do
        @mc.method_name.should.equal :my_method
      end

      it "should have 1 argument recording" do
        @mc.args.size.should.equal 1
      end

      it "should have the correct arguments" do
        @mc.args.should.equal [Caricature::ArgumentRecording.new([1, 2])]
      end

      it "should have no block" do
         @mc.block.should.equal nil
      end

      it "should have a count a 1" do
        @mc.count.should.equal 1
      end

    end

  end

  describe "when recording 2 calls with no arguments" do

    before do
      @recorder.record_call :my_method
      @recorder.record_call :my_method
    end

    it "should have 1 method call" do
      @recorder.method_calls.size.should.equal 1
    end

    describe "recorded call" do

      before do
        @mc = @recorder.method_calls[:my_method]
      end

      it "should have a method call collected" do
        @mc.should.not.equal nil
      end

      it "should have the correct name" do
        @mc.method_name.should.equal :my_method
      end

      it "should have no arguments" do
        @mc.args.should.equal [Caricature::ArgumentRecording.new]
      end

      it "should have no block" do
         @mc.block.should.equal nil
      end

      it "should have a count a 1" do
        @mc.count.should.equal 2
      end

    end

  end

  describe "when recording 2 calls with different arguments" do

    before do
      @recorder.record_call :my_method
      @recorder.record_call :my_method, 1, 3, 4
    end

    it "should have 1 method call" do
      @recorder.method_calls.size.should.equal 1
    end

    describe "recorded call" do

      before do
        @mc = @recorder.method_calls[:my_method]
      end

      it "should have a method call collected" do
        @mc.should.not.equal nil
      end

      it "should have the correct name" do
        @mc.method_name.should.equal :my_method
      end

      it "should have argument variations" do
        @mc.has_argument_variations?.should.be.true?
      end

      it "should have no block" do
         @mc.block.should.equal nil
      end

      it "should have a count a 1" do
        @mc.count.should.equal 2
      end

    end

  end

end