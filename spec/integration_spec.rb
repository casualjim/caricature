require File.dirname(__FILE__) + "/bacon_helper"

describe "Full scenarios" do

  describe "when isolating CLR interfaces" do
    before do
      @ninja = ClrModels::Ninja.new      
      @weapon = Caricature::Isolation.for(ClrModels::IWeapon)
    end

    it "should work without expectations" do
      @ninja.attack ClrModels::Ninja.new, @weapon

      @weapon.was_told_to?(:attack).should.be.successful
    end

    it "should work with an expectation" do
      @weapon.when_told_to(:damage).return(5)

      @ninja.is_killed_by(@weapon).should.be.true?
      @weapon.was_told_to?(:damage).should.be.successful
    end

    it "should work with an expectation getting different method call result" do
      @weapon.when_told_to(:damage).return(2)

      @ninja.is_killed_by(@weapon).should.be.false?
      @weapon.was_told_to?(:damage).should.be.successful
    end

    it "should work for an assertion on a specific argument" do
      @weapon.when_told_to(:damage).return(2)

      @ninja.is_killed_by(@weapon).should.be.false?
      @weapon.was_told_to?(:damage).should.be.successful
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

      @ninja.was_told_to?(:survive_attack_with).with(@weapon).should.be.successful
    end

    it "should work with an expectation for any arguments" do
      @ninja.when_told_to(:survive_attack_with).return(5)

      result = @weapon.attack @ninja
      result.should.equal 5

      @ninja.was_told_to?(:survive_attack_with).with(:any).should.be.successful
    end

    it "should work with an assertion for specific arguments" do
      @ninja.when_told_to(:survive_attack_with) do |method_should|
         method_should.return(5)
      end

      result = @weapon.attack @ninja
      result.should.equal 5

      @ninja.was_told_to?(:survive_attack_with).with(@weapon).should.be.successful
    end

    it "should fail for an assertion with wrong arguments" do
      @ninja.when_told_to(:survive_attack_with) do |method_should|
         method_should.return(5)
      end

      result = @weapon.attack @ninja
      result.should.equal 5

      @ninja.
        was_told_to?(:survive_attack_with).
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

      @ninja.was_told_to?(:survive_attack_with).with(@weapon).should.be.successful
    end

    it "should work with an expectation for any arguments" do
      @ninja.when_told_to(:survive_attack_with).return(5)

      result = @weapon.attack @ninja
      result.should.equal 5

      @ninja.was_told_to?(:survive_attack_with).with(:any).should.be.successful
    end

    it "should fail for an assertion for specific arguments" do
      @ninja.when_told_to(:survive_attack_with) do |method_should|
         method_should.return(5)
      end

      result = @weapon.attack @ninja
      result.should.equal 5
      var = @ninja.was_told_to?(:survive_attack_with).with(:any)
      @ninja.was_told_to?(:survive_attack_with).with(@weapon).should.be.successful
    end

    it "should allow to delegate the method call to the real instance (partial mock)" do
      @ninja.when_told_to(:survive_attack_with).super_after

      result = @weapon.attack @ninja
      result.should.equal 6

      @ninja.was_told_to?(:survive_attack_with).should.be.successful
    end

  end

end