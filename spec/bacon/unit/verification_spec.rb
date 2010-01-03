require File.dirname(__FILE__) + "/../spec_helper"

describe "Caricature::Verification" do

  describe "Matching" do

    before do
      @rec = Caricature::MethodCallRecorder.new
      @ver = Caricature::Verification.new(:my_method, @rec)
    end

    describe "Default initialisation" do

      it "should allow any arguments" do
        @ver.any_args?.should.be.true?
      end

      it "should match the provided method name when no arguments have been given" do
        @ver.matches?(:my_method).should.be.true?
      end

      it "should match the method name when arguments have been given" do
        @ver.matches?(:my_method, 1, 3, 4).should.be.true?
      end

    end

    describe "when initialized with and constrained by arguments" do

      before do
        @ver.with(1, 3, 6)
      end

      it "should match the provided method name when the correct arguments are given" do
        @ver.matches?(:my_method, 1, 3, 6).should.be.true?
      end

      it "should not match the method name when the arguments are not correct" do
        @ver.matches?(:my_method, 1, 3, 3).should.be.false?
      end

      it "should not match the method name when no arguments have been given" do
        @ver.matches?(:my_method).should.be.false?
      end

    end

    describe "when initialized with and not constrained by arguments" do

      before do
        @ver.with(1, 3, 6).allow_any_arguments
      end

      it "should match the provided method name when the correct arguments are given" do
        @ver.matches?(:my_method, 1, 3, 6).should.be.true?
      end

      it "should match the method name when the arguments are not correct" do
        @ver.matches?(:my_method, 1, 3, 3).should.be.true?
      end

      it "should match the method name when no arguments have been given" do
        @ver.matches?(:my_method).should.be.true?
      end

    end
    
  end

  describe "Verifying" do

    before do
      @rec = Caricature::MethodCallRecorder.new
      @rec.record_call :my_method
      @rec.record_call :my_method, :instance, nil, 1, 2, 3
      @rec.record_call :another_method

    end

    it "should be successful with any arguments allowed" do
      ver = Caricature::Verification.new(:my_method, @rec)
      ver.should.be.successful
    end

    it "should be successful with a correct set of arguments provided for my_method" do
      ver = Caricature::Verification.new(:my_method, @rec)
      ver.with 1, 2, 3
      ver.should.be.successful
    end

    it "should be unsuccessful when a wrong set of arguments is provided" do
      ver = Caricature::Verification.new(:my_method, @rec)
      ver.with 1, 5, 7
      ver.should.not.be.successful
    end

    it "should be unsuccessful when the wrong method name is provided" do
      ver = Caricature::Verification.new(:some_method, @rec)
      ver.should.not.be.successful
    end

  end
  
end