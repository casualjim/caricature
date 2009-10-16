require File.dirname(__FILE__) + "/../spec_helper"

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
    
    it "should have no callback" do
      @expectation.should.not.has_callback?
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

    it "should have a return callback" do
      @expectation.return_callback.should.not.be.nil
    end

    it "should have the correct return_value" do
      @expectation.return_callback.call.should.equal 5
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
  
  describe "when giving a block to the arguments constraint it should register it as a callback" do      
    
    before do
      builder = Caricature::ExpectationBuilder.new :some_method
      @counter, @args = 0, []
      builder.with(5) do |*ags| 
        @counter += 1 
        @args = ags
      end
      @expectation = builder.build
    end
    
    it "should have a callback" do
      @expectation.should.has_callback?
    end                                
    
    it "should call the callback when the expectation is called" do
      @expectation.execute
      @counter.should == 1
    end  
    
    it "should pass on the correct arguments" do
      @expectation.execute 1, 2, 3
      @args.should == [1, 2, 3]
    end
  end

  describe "when giving a block to a super method it should register it" do

    before do
      builder = Caricature::ExpectationBuilder.new :some_method
      @counter = 0
      builder.super_after do
        @counter += 1
      end
      @expectation = builder.build
    end

    it "should should have a callback" do
      @expectation.block.should.not.be.nil
    end

    it "should pass on the correct callback" do
      @expectation.block.call
      @counter.should == 1
    end

  end

  describe "when given arguments to the block pass method" do

    before do
      builder = Caricature::ExpectationBuilder.new :some_method
      builder.pass_block(1,2,3)
      @expectation = builder.build
    end

    it "should not have a block callback" do
      @expectation.should.not.has_block_callback
    end

    it "should should execute the block with the provided arguments when executed" do
      ags = []
      @expectation.execute do |*args|
        ags = args
      end
      ags.should == [1,2,3]
    end

  end

  describe "when given arguments to the block pass method" do

    before do
      builder = Caricature::ExpectationBuilder.new :some_method
      builder.pass_block do
       [1,3,4]
      end
      @expectation = builder.build
    end

    it "should have a block callback" do
      @expectation.should.has_block_callback
    end

    it "should execute the block with the result of the provided callback when executed" do
      ags = []
      @expectation.execute do |*args|
        ags = args
      end
      ags.should == [1,3,4]
    end

  end

end