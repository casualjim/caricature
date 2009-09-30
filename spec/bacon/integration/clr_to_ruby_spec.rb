require File.dirname(__FILE__) + "/../spec_helper"

describe "CLR isolations for ruby objects" do

  describe "when isolating CLR interfaces" do
    before do
      @soldier = Soldier.new
      @weapon = Caricature::Isolation.for(ClrModels::IWeapon)
    end

    it "should work without expectations" do
      @soldier.attack Soldier.new, @weapon

      @weapon.did_receive?(:attack).should.be.successful
    end

    it "should work for expectations with an argument constraint" do
      soldier = Soldier.new
      @weapon.when_receiving(:attack).with(soldier).return(5)

      @soldier.attack(soldier, @weapon).should.equal 5

      @weapon.did_receive?(:attack).with(:any).should.be.successful
    end

    it "should work for expectations with an argument constraint when a wrong argument is passed in" do
      @weapon.when_receiving(:attack).with(Soldier.new).return(5)

      @soldier.attack(Soldier.new, @weapon).should.equal 0
    end

    it "should work for expectations with an argument constraint and an assertion argument constraint" do
      soldier = Soldier.new
      @weapon.when_receiving(:attack).with(soldier).return(5)

      @soldier.attack(soldier, @weapon).should.equal 5

      @weapon.did_receive?(:attack).with(soldier).should.be.successful
    end

    it "should fail for expectations with an argument constraint and an assertion argument constraint" do
      soldier = Soldier.new
      @weapon.when_receiving(:attack).with(soldier).return(5)

      @soldier.attack(soldier, @weapon).should.equal 5

      @weapon.did_receive?(:attack).with(Soldier.new).should.not.be.successful
    end

    it "should work with an expectation with any arguments" do
      @weapon.when_receiving(:damage).return(5)

      @soldier.is_killed_by?(@weapon).should.be.true?
      @weapon.did_receive?(:damage).should.be.successful
    end

    it "should work with an expectation getting different method call result" do
      @weapon.when_receiving(:damage).return(2)

      @soldier.is_killed_by?(@weapon).should.be.false?
      @weapon.did_receive?(:damage).should.be.successful
    end

    it "should work for an assertion on a specific argument" do
      @weapon.when_receiving(:damage).return(2)

      @soldier.is_killed_by?(@weapon).should.be.false?
      @weapon.did_receive?(:damage).should.be.successful
    end

  end

  describe "when isolating CLR classes" do

    before do
      @weapon = Dagger.new
      @ninja = Caricature::Isolation.for(ClrModels::Ninja)
    end

    it "should work without expectations" do
      result = @weapon.attack @ninja
      result.should.equal 0

      @ninja.did_receive?(:survive_attack_with).with(@weapon).should.be.successful
    end

    it "should work for expectations with an argument constraint" do
      @ninja.when_receiving(:survive_attack_with).with(@weapon).return(5)

      @weapon.attack(@ninja).should.equal 5

      @ninja.did_receive?(:survive_attack_with).with(:any).should.be.successful
    end

    it "should work for expectations with an argument constraint when a wrong argument is passed in" do
      @ninja.when_receiving(:survive_attack_with).with(@weapon).return(5)

      @weapon.attack(Soldier.new).should.equal 8

      @ninja.did_receive?(:survive_attack_with).with(@weapon).should.not.be.successful
    end

    it "should work for expectations with an argument constraint and an assertion argument constraint" do
      ninja = ClrModels::Ninja.new
      @ninja.when_receiving(:survive_attack_with).with(@weapon).return(5)

      @weapon.attack(@ninja).should.equal 5

      @ninja.did_receive?(:survive_attack_with).with(@weapon).should.be.successful
    end

    it "should fail for expectations with an argument constraint and an assertion argument constraint" do
      ninja = ClrModels::Ninja.new
      @ninja.when_receiving(:survive_attack_with).with(@weapon).return(5)

      @weapon.attack(@ninja).should.equal 5

      @ninja.did_receive?(:survive_attack_with).with(Dagger.new).should.not.be.successful
    end

    it "should work with an expectation for any arguments" do
      @ninja.when_receiving(:survive_attack_with).return(5)

      result = @weapon.attack @ninja
      result.should.equal 5

      @ninja.did_receive?(:survive_attack_with).with(:any).should.be.successful
    end

    it "should work with an assertion for specific arguments" do
      @ninja.when_receiving(:survive_attack_with) do |method_should|
        method_should.return(5)
      end

      result = @weapon.attack @ninja
      result.should.equal 5

      @ninja.did_receive?(:survive_attack_with).with(@weapon).should.be.successful
    end

    it "should fail for an assertion with wrong arguments" do
      @ninja.when_receiving(:survive_attack_with) do |method_should|
        method_should.return(5)
      end

      result = @weapon.attack @ninja
      result.should.equal 5

      @ninja.
              did_receive?(:survive_attack_with).
              with(Caricature::Isolation.for(ClrModels::IWeapon)).
              should.not.be.successful
    end

  end

  describe "when isolating CLR instances" do

    before do
      @weapon = Dagger.new
      @ninja = Caricature::Isolation.for(ClrModels::Ninja.new)
    end

    it "should work without expectations" do
      result = @weapon.attack @ninja
      result.should.equal 0

      @ninja.did_receive?(:survive_attack_with).with(@weapon).should.be.successful
    end

    it "should work for expectations with an argument constraint" do
      @ninja.when_receiving(:survive_attack_with).with(@weapon).return(5)

      @weapon.attack(@ninja).should.equal 5

      @ninja.did_receive?(:survive_attack_with).with(:any).should.be.successful
    end

    it "should work for expectations with an argument constraint when a wrong argument is passed in" do
      @ninja.when_receiving(:survive_attack_with).with(@weapon).return(5)

      @weapon.attack(Soldier.new).should.equal 8

      @ninja.did_receive?(:survive_attack_with).with(@weapon).should.not.be.successful
    end

    it "should work for expectations with an argument constraint and an assertion argument constraint" do
      ninja = ClrModels::Ninja.new
      @ninja.when_receiving(:survive_attack_with).with(@weapon).return(5)

      @weapon.attack(@ninja).should.equal 5

      @ninja.did_receive?(:survive_attack_with).with(@weapon).should.be.successful
    end

    it "should fail for expectations with an argument constraint and an assertion argument constraint" do
      ninja = ClrModels::Ninja.new
      @ninja.when_receiving(:survive_attack_with).with(@weapon).return(5)

      @weapon.attack(@ninja).should.equal 5

      @ninja.did_receive?(:survive_attack_with).with(Dagger.new).should.not.be.successful
    end

    it "should work with an expectation for any arguments" do
      @ninja.when_receiving(:survive_attack_with).return(5)

      result = @weapon.attack @ninja
      result.should.equal 5

      @ninja.did_receive?(:survive_attack_with).with(:any).should.be.successful
    end

    it "should fail for an assertion for specific arguments" do
      @ninja.when_receiving(:survive_attack_with) do |method_should|
        method_should.return(5)
      end

      result = @weapon.attack @ninja
      result.should.equal 5
      var = @ninja.did_receive?(:survive_attack_with).with(:any)
      @ninja.did_receive?(:survive_attack_with).with(@weapon).should.be.successful
    end


  end

end