require File.dirname(__FILE__) + "/../spec_helper"

describe "Ruby to Ruby interactions" do

  describe "when isolating Ruby classes" do

    before do
      @dagger = Dagger.new
      @soldier = Caricature::Isolation.for(Soldier)
    end

    it "should work without expectations" do
      result = @dagger.attack @soldier
      result.should.equal nil

      @soldier.did_receive?(:survive_attack_with).with(@dagger).should.be.successful
    end

    it "should work for expectations with an argument constraint" do
      @soldier.when_receiving(:survive_attack_with).with(@dagger).return(5)

      @dagger.attack(@soldier).should.equal 5

      @soldier.did_receive?(:survive_attack_with).with(:any).should.be.successful
    end

    it "should work for expectations with an argument constraint when a wrong argument is passed in" do
      @soldier.when_receiving(:survive_attack_with).with(@dagger).return(5)

      @dagger.attack(Soldier.new).should.equal 8

      @soldier.did_receive?(:survive_attack_with).with(@dagger).should.not.be.successful
    end

    it "should work for expectations with an argument constraint and an assertion argument constraint" do
      soldier = Soldier.new
      @soldier.when_receiving(:survive_attack_with).with(@dagger).return(5)

      @dagger.attack(@soldier).should.equal 5

      @soldier.did_receive?(:survive_attack_with).with(@dagger).should.be.successful
    end

    it "should fail for expectations with an argument constraint and an assertion argument constraint" do
      soldier = Soldier.new
      @soldier.when_receiving(:survive_attack_with).with(@dagger).return(5)

      @dagger.attack(@soldier).should.equal 5

      @soldier.did_receive?(:survive_attack_with).with(Dagger.new).should.not.be.successful
    end

    it "should work with an expectation for any arguments" do
      @soldier.when_receiving(:survive_attack_with).return(5)

      result = @dagger.attack @soldier
      result.should.equal 5

      @soldier.did_receive?(:survive_attack_with).with(:any).should.be.successful
    end

    it "should work with an assertion for specific arguments" do
      @soldier.when_receiving(:survive_attack_with) do |method_should|
        method_should.return(5)
      end

      result = @dagger.attack @soldier
      result.should.equal 5

      @soldier.did_receive?(:survive_attack_with).with(@dagger).should.be.successful
    end

    it "should fail for an assertion with wrong arguments" do
      @soldier.when_receiving(:survive_attack_with) do |method_should|
        method_should.return(5)
      end

      result = @dagger.attack @soldier
      result.should.equal 5

      @soldier.
              did_receive?(:survive_attack_with).
              with(Caricature::Isolation.for(Dagger)).
              should.not.be.successful
    end

  end

  describe "when isolating Ruby classes with class members" do

    before do
      @dagger = Dagger.new
      @soldier = Caricature::Isolation.for(SoldierWithClassMembers)
    end

    it "should work without expectations" do
      result = @dagger.attack @soldier
      result.should.equal nil

      @soldier.did_receive?(:survive_attack_with).with(@dagger).should.be.successful
    end

    it "should work for expectations with an argument constraint" do
      @soldier.when_receiving(:survive_attack_with).with(@dagger).return(5)

      @dagger.attack(@soldier).should.equal 5

      @soldier.did_receive?(:survive_attack_with).with(:any).should.be.successful
    end

    it "should work for an expctation on a class method without an argument constraint" do
      @soldier.when_class_receives(:class_name).return(5)

      @soldier.class.class_name.should.equal 5

      @soldier.did_class_receive?(:class_name).should.be.successful
    end

    it "should work for expectations with an argument constraint when a wrong argument is passed in" do
      @soldier.when_receiving(:survive_attack_with).with(@dagger).return(5)

      @dagger.attack(Soldier.new).should.equal 8

      @soldier.did_receive?(:survive_attack_with).with(@dagger).should.not.be.successful
    end

    it "should work for expectations with an argument constraint and an assertion argument constraint" do
      soldier = Soldier.new
      @soldier.when_receiving(:survive_attack_with).with(@dagger).return(5)

      @dagger.attack(@soldier).should.equal 5

      @soldier.did_receive?(:survive_attack_with).with(@dagger).should.be.successful
    end

    it "should fail for expectations with an argument constraint and an assertion argument constraint" do
      soldier = Soldier.new
      @soldier.when_receiving(:survive_attack_with).with(@dagger).return(5)

      @dagger.attack(@soldier).should.equal 5

      @soldier.did_receive?(:survive_attack_with).with(Dagger.new).should.not.be.successful
    end

    it "should work with an expectation for any arguments" do
      @soldier.when_receiving(:survive_attack_with).return(5)

      result = @dagger.attack @soldier
      result.should.equal 5

      @soldier.did_receive?(:survive_attack_with).with(:any).should.be.successful
    end

    it "should work with an assertion for specific arguments" do
      @soldier.when_receiving(:survive_attack_with) do |method_should|
        method_should.return(5)
      end

      result = @dagger.attack @soldier
      result.should.equal 5

      @soldier.did_receive?(:survive_attack_with).with(@dagger).should.be.successful
    end

    it "should fail for an assertion with wrong arguments" do
      @soldier.when_receiving(:survive_attack_with) do |method_should|
        method_should.return(5)
      end

      result = @dagger.attack @soldier
      result.should.equal 5

      @soldier.
              did_receive?(:survive_attack_with).
              with(Caricature::Isolation.for(Dagger)).
              should.not.be.successful
    end

  end

  describe "when isolating Ruby instances" do

    before do
      @dagger = Dagger.new
      @soldier = Caricature::Isolation.for(Soldier.new)
    end

    it "should work without expectations" do
      result = @dagger.attack @soldier
      result.should.equal nil

      @soldier.did_receive?(:survive_attack_with).with(@dagger).should.be.successful
    end

    it "should work for expectations with an argument constraint" do
      @soldier.when_receiving(:survive_attack_with).with(@dagger).return(5)

      @dagger.attack(@soldier).should.equal 5

      @soldier.did_receive?(:survive_attack_with).with(:any).should.be.successful
    end

    it "should work for expectations with an argument constraint when a wrong argument is passed in" do
      @soldier.when_receiving(:survive_attack_with).with(@dagger).return(5)

      @dagger.attack(Soldier.new).should.equal 8

      @soldier.did_receive?(:survive_attack_with).with(@dagger).should.not.be.successful
    end

    it "should work for expectations with an argument constraint and an assertion argument constraint" do
      soldier = Soldier.new
      @soldier.when_receiving(:survive_attack_with).with(@dagger).return(5)

      @dagger.attack(@soldier).should.equal 5

      @soldier.did_receive?(:survive_attack_with).with(@dagger).should.be.successful
    end

    it "should fail for expectations with an argument constraint and an assertion argument constraint" do
      soldier = Soldier.new
      @soldier.when_receiving(:survive_attack_with).with(@dagger).return(5)

      @dagger.attack(@soldier).should.equal 5

      @soldier.did_receive?(:survive_attack_with).with(Dagger.new).should.not.be.successful
    end

    it "should work with an expectation for any arguments" do
      @soldier.when_receiving(:survive_attack_with).return(5)

      result = @dagger.attack @soldier
      result.should.equal 5

      @soldier.did_receive?(:survive_attack_with).with(:any).should.be.successful
    end

    it "should fail for an assertion for specific arguments" do
      @soldier.when_receiving(:survive_attack_with) do |method_should|
        method_should.return(5)
      end

      result = @dagger.attack @soldier
      result.should.equal 5
      var = @soldier.did_receive?(:survive_attack_with).with(:any)
      @soldier.did_receive?(:survive_attack_with).with(@dagger).should.be.successful
    end

    it "should allow to delegate the method call to the real instance (partial mock)" do
      @soldier.when_receiving(:survive_attack_with).super_after

      result = @dagger.attack @soldier
      result.should.equal 8

      @soldier.did_receive?(:survive_attack_with).should.be.successful
    end
    
    it "should be able to isolate objects with constructor params" do
      sheath = Caricature::Isolation.for(Sheath)   
      sheath.when_receiving(:insert).raise("Overridden")
      lambda { sheath.insert(@dagger) }.should.raise.message.should.match(/Overridden/)
    end 
    
    it "should be able to isolate objects with constructor params" do
      sheath = Caricature::Isolation.for(Sheath)
        lambda { sheath.insert(@dagger) }.should.not.raise
    end

  end  

end