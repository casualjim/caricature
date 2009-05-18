require File.dirname(__FILE__) + "/bacon_helper"

describe "Caricature::Isolation" do

  describe "when creating an isolation for ruby objects" do

    it "should not raise" do
      lambda { Caricature::Isolation.for(Soldier) }.should.not.raise
    end

  end

  describe "after creation of the isolation for a ruby object" do

    before do
      @isolator = Caricature::Isolation.for(Soldier)
    end

    it "should create a proxy" do
      @isolator.should.not.be == nil
    end

    describe "when asked to stub a method" do

      it "should create an expectation with a block" do
        nm = "What's in a name"
        expectation = @isolator.when_receiving(:name) do |cl|
          cl.return(nm)
        end
        expectation.method_name.should.equal :name
        expectation.has_return_value?.should.be.true?
        expectation.return_value.should.equal nm
      end

      it "should create an expectation without a block" do
        nm = "What's in a name"
        expectation = @isolator.when_receiving(:name).return(nm)
        expectation.method_name.should.equal :name
        expectation.has_return_value?.should.be.true?
        expectation.return_value.should.equal nm
      end
    end

  end
    
  describe "when creating an isolation for CLR objects" do

    it "should not raise" do
      lambda { Caricature::Isolation.for(ClrModels::Ninja) }.should.not.raise
    end

  end

  describe "after creation of the isolation for a CLR object" do

    before do
      @isolator = Caricature::Isolation.for(ClrModels::Ninja)
    end

    it "should create a proxy" do
      @isolator.should.not.be == nil
    end

    describe "when asked to stub a method" do

      it "should create an expectation with a block" do
        nm = "What's in a name"
        expectation = @isolator.when_receiving(:name) do |cl|
          cl.return(nm)
        end
        expectation.method_name.should.equal :name
        expectation.has_return_value?.should.be.true?
        expectation.return_value.should.equal nm
      end

      it "should create an expectation without a block" do
        nm = "What's in a name"
        expectation = @isolator.when_receiving(:name).return(nm)
        expectation.method_name.should.equal :name
        expectation.has_return_value?.should.be.true?
        expectation.return_value.should.equal nm
      end
    end

  end

end