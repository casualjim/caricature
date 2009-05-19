require File.dirname(__FILE__) + "/bacon_helper"

describe "Full scenarios" do

  describe "CLR to CLR interactions" do

    describe "when isolating CLR interfaces" do
      before do
        @ninja = ClrModels::Ninja.new
        @weapon = Caricature::Isolation.for(ClrModels::IWeapon)
      end

      it "should work without expectations" do
        @ninja.attack ClrModels::Ninja.new, @weapon

        @weapon.did_receive?(:attack).should.be.successful
      end

      it "should work for expectations with an argument constraint" do
        ninja = ClrModels::Ninja.new
        @weapon.when_receiving(:attack).with(ninja).return(5)

        @ninja.attack(ninja, @weapon).should.equal 5

        @weapon.did_receive?(:attack).with(:any).should.be.successful
      end

       it "should work for expectations with an argument constraint when a wrong argument is passed in" do
        @weapon.when_receiving(:attack).with(ClrModels::Ninja.new).return(5)

        @ninja.attack(ClrModels::Ninja.new, @weapon).should.equal 0
      end

      it "should work for expectations with an argument constraint and an assertion argument constraint" do
        ninja = ClrModels::Ninja.new
        @weapon.when_receiving(:attack).with(ninja).return(5)

        @ninja.attack(ninja, @weapon).should.equal 5

        @weapon.did_receive?(:attack).with(ninja).should.be.successful
      end

       it "should fail for expectations with an argument constraint and an assertion argument constraint" do
        ninja = ClrModels::Ninja.new
        @weapon.when_receiving(:attack).with(ninja).return(5)

        @ninja.attack(ninja, @weapon).should.equal 5

        @weapon.did_receive?(:attack).with(ClrModels::Ninja.new).should.not.be.successful
      end

      it "should work with an expectation with any arguments" do
        @weapon.when_receiving(:damage).return(5)

        @ninja.is_killed_by(@weapon).should.be.true?
        @weapon.did_receive?(:damage).should.be.successful
      end

      it "should work with an expectation getting different method call result" do
        @weapon.when_receiving(:damage).return(2)

        @ninja.is_killed_by(@weapon).should.be.false?
        @weapon.did_receive?(:damage).should.be.successful
      end

      it "should work for an assertion on a specific argument" do
        @weapon.when_receiving(:damage).return(2)

        @ninja.is_killed_by(@weapon).should.be.false?
        @weapon.did_receive?(:damage).should.be.successful
      end

    end

    describe "when isolating CLR classes" do

      before do
        @weapon = ClrModels::Sword.new
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

        @weapon.attack(ClrModels::Ninja.new).should.equal 6

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

        @ninja.did_receive?(:survive_attack_with).with(ClrModels::Sword.new).should.not.be.successful
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
        @weapon = ClrModels::Sword.new
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

        @weapon.attack(ClrModels::Ninja.new).should.equal 6

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

        @ninja.did_receive?(:survive_attack_with).with(ClrModels::Sword.new).should.not.be.successful
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

      it "should allow to delegate the method call to the real instance (partial mock)" do
        @ninja.when_receiving(:survive_attack_with).super_after

        result = @weapon.attack @ninja
        result.should.equal 6

        @ninja.did_receive?(:survive_attack_with).should.be.successful
      end

    end

  end

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

    end

  end

end