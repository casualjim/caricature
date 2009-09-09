require File.dirname(__FILE__) + "/../bacon_helper"

describe "Caricature::Expectations" do

end

describe "Caricature::ExpectationBuilder" do

  it "should create an expectation builder" do
    builder = Caricature::ExpectationBuilder.new :some_method
    builder.should.not.equal nil
  end

  describe "when using all defaults" do

    before do
      builder = Caricature::ExpectationBuilder.new :some_method
      @expectation = builder.build
    end

    it "should have the correct method_name" do
      @expectation.method_name.should.equal :some_method
    end

    it "should have empty args" do
      @expectation.args.should.be.empty?
    end

    it "should have no super call" do
      @expectation.super.should.equal nil
    end

    it "should have no error args" do
      @expectation.error_args.should.equal nil
    end

    it "should have no return_value" do
      @expectation.return_value.should.equal nil
    end                
    
    it "should have no callback" do
      @expectation.should.not.has_callback?
    end

  end

  describe "when specifying only arguments" do

    before do
      builder = Caricature::ExpectationBuilder.new :some_method
      builder.with(1, 2, 3)
      @expectation = builder.build
    end

    it "should have the correct method_name" do
      @expectation.method_name.should.equal :some_method
    end

    it "should have empty args" do
      @expectation.args.should.equal [1,2,3]
    end

    it "should have no super call" do
      @expectation.super.should.equal nil
    end

    it "should have no error args" do
      @expectation.error_args.should.equal nil
    end

    it "should have no return_value" do
      @expectation.return_value.should.equal nil
    end

  end

  describe "when specifying only a block for the return value" do

    before do
      builder = Caricature::ExpectationBuilder.new :some_method
      builder.return {  5 }
      @expectation = builder.build
    end

    it "should have the correct method_name" do
      @expectation.method_name.should.equal :some_method
    end

    it "should have empty args" do
      @expectation.args.should.be.empty?
    end

    it "should have no super call" do
      @expectation.super.should.equal nil
    end

    it "should have no error args" do
      @expectation.error_args.should.equal nil
    end

    it "should have the correct return_value" do
      @expectation.return_value.should.equal 5
    end

  end

  describe "when specifying a return value" do

    before do
      builder = Caricature::ExpectationBuilder.new :some_method
      builder.return 5
      @expectation = builder.build
    end

    it "should have the correct method_name" do
      @expectation.method_name.should.equal :some_method
    end

    it "should have empty args" do
      @expectation.args.should.be.empty?
    end

    it "should have no super call" do
      @expectation.super.should.equal nil
    end

    it "should have no error args" do
      @expectation.error_args.should.equal nil
    end

    it "should have the correct return_value" do
      @expectation.return_value.should.equal 5
    end

  end

  describe "when specifying a raise arguments" do

    before do
      @msg = "Hold on, that wasn't supposed to happen"
      builder = Caricature::ExpectationBuilder.new :some_method
      builder.raise @msg
      @expectation = builder.build
    end

    it "should have the correct method_name" do
      @expectation.method_name.should.equal :some_method
    end

    it "should have empty args" do
      @expectation.args.should.be.empty?
    end

    it "should have no super call" do
      @expectation.super.should.equal nil
    end

    it "should have no error args" do
      @expectation.error_args.should.equal [@msg]
    end

    it "should have the correct return_value" do
      @expectation.return_value.should.equal nil
    end

  end

  describe "when specifying a return value and telling you want a call to super before" do

    before do
      builder = Caricature::ExpectationBuilder.new :some_method
      builder.return(5).super_before
      @expectation = builder.build
    end

    it "should have the correct method_name" do
      @expectation.method_name.should.equal :some_method
    end

    it "should have empty args" do
      @expectation.args.should.be.empty?
    end

    it "should have no super call" do
      @expectation.super.should.equal :before
    end

    it "should have no error args" do
      @expectation.error_args.should.equal nil
    end

    it "should have the correct return_value" do
      @expectation.return_value.should.equal 5
    end

  end

end