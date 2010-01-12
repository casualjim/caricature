require File.dirname(__FILE__) + "/../spec_helper"

shared 'camel cased naming interceptions' do
  
  it "should work without expectations" do
    @ninja.attack ClrModels::Ninja.new, @weapon

    @weapon.should.have_received?(:Attack)
  end

  it "should work for expectations with an argument constraint" do
    ninja = ClrModels::Ninja.new
    @weapon.when_receiving(:Attack).with(ninja).return(5)

    @ninja.attack(ninja, @weapon).should.equal 5

    @weapon.should.have_received?(:Attack) { |ver| ver.with(:any) }
  end

  it "should work for expectations with an argument constraint when a wrong argument is passed in" do
    @weapon.when_receiving(:Attack).with(ClrModels::Ninja.new).return(5)

    @ninja.attack(ClrModels::Ninja.new, @weapon).should.equal 0
  end

  it "should work for expectations with an argument constraint and an assertion argument constraint" do
    ninja = ClrModels::Ninja.new
    @weapon.when_receiving(:Attack).with(ninja).return(5)

    @ninja.attack(ninja, @weapon).should.equal 5

    @weapon.should.have_received?(:Attack) { |v| v.with(ninja) }
  end

  it "should fail for expectations with an argument constraint and an assertion argument constraint" do
    ninja = ClrModels::Ninja.new
    @weapon.when_receiving(:Attack).with(ninja).return(5)

    @ninja.attack(ninja, @weapon).should.equal 5

    @weapon.should.not.have_received?(:Attack){ |v| v.with(ClrModels::Ninja.new) }
  end

  it "should work with an expectation with any arguments" do
    @weapon.when_receiving(:Damage).return(5)

    @ninja.is_killed_by(@weapon).should.be.true?
    @weapon.should.have_received?(:Damage)
  end

  it "should work with an expectation getting different method call result" do
    @weapon.when_receiving(:Damage).return(2)

    @ninja.is_killed_by(@weapon).should.be.false?
    @weapon.should.have_received?(:Damage)
  end

  it "should work for an assertion on a specific argument" do
    @weapon.when_receiving(:Damage).return(2)

    @ninja.is_killed_by(@weapon).should.be.false?
    @weapon.should.have_received?(:Damage)
  end
  
end

describe "CLR to CLR interactions" do
  
  describe "when using camel cased names" do
    
    before do
      @ninja = ClrModels::Ninja.new
      @weapon = isolate ClrModels::IWeapon
    end
    
    
    behaves_like 'camel cased naming interceptions'
    
  end

  describe "when isolating CLR interfaces" do
    before do
      @ninja = ClrModels::Ninja.new
      @weapon = isolate ClrModels::IWeapon
    end

    it "should work without expectations" do
      @ninja.attack ClrModels::Ninja.new, @weapon

      @weapon.should.have_received?(:attack)
    end

    it "should work for expectations with an argument constraint" do
      ninja = ClrModels::Ninja.new
      @weapon.when_receiving(:attack).with(ninja).return(5)

      @ninja.attack(ninja, @weapon).should.equal 5

      @weapon.should.have_received?(:attack) { |ver| ver.with(:any) }
    end

    it "should work for expectations with an argument constraint when a wrong argument is passed in" do
      @weapon.when_receiving(:attack).with(ClrModels::Ninja.new).return(5)

      @ninja.attack(ClrModels::Ninja.new, @weapon).should.equal 0
    end

    it "should work for expectations with an argument constraint and an assertion argument constraint" do
      ninja = ClrModels::Ninja.new
      @weapon.when_receiving(:attack).with(ninja).return(5)

      @ninja.attack(ninja, @weapon).should.equal 5

      @weapon.should.have_received?(:attack) { |v| v.with(ninja) }
    end

    it "should fail for expectations with an argument constraint and an assertion argument constraint" do
      ninja = ClrModels::Ninja.new
      @weapon.when_receiving(:attack).with(ninja).return(5)

      @ninja.attack(ninja, @weapon).should.equal 5

      @weapon.should.not.have_received?(:attack){ |v| v.with(ClrModels::Ninja.new) }
    end

    it "should work with an expectation with any arguments" do
      @weapon.when_receiving(:damage).return(5)

      @ninja.is_killed_by(@weapon).should.be.true?
      @weapon.should.have_received?(:damage)
    end

    it "should work with an expectation getting different method call result" do
      @weapon.when_receiving(:damage).return(2)

      @ninja.is_killed_by(@weapon).should.be.false?
      @weapon.should.have_received?(:damage)
    end

    it "should work for an assertion on a specific argument" do
      @weapon.when_receiving(:damage).return(2)

      @ninja.is_killed_by(@weapon).should.be.false?
      @weapon.should.have_received?(:damage)
    end

  end

  describe "when isolating CLR classes" do

    describe "plain vanilla CLR classes" do
      before do
        @weapon = ClrModels::Sword.new
        @ninja = isolate ClrModels::Ninja
      end

      it "should work without expectations" do
        result = @weapon.attack @ninja
        result.should.equal 0

        @ninja.should.have_received?(:survive_attack_with) { |v| v.with(@weapon) }
      end

      it "should work for expectations with an argument constraint" do
        @ninja.when_receiving(:survive_attack_with).with(@weapon).return(5)

        @weapon.attack(@ninja).should.equal 5

        @ninja.should.have_received?(:survive_attack_with) { |v| v.with(:any) }
      end

      it "should work for expectations with an argument constraint when a wrong argument is passed in" do
        @ninja.when_receiving(:survive_attack_with).with(@weapon).return(5)

        @weapon.attack(ClrModels::Ninja.new).should.equal 6

        @ninja.should.not.have_received?(:survive_attack_with) { |v| v.with(@weapon) }
      end

      it "should work for expectations with an argument constraint and an assertion argument constraint" do
        ninja = ClrModels::Ninja.new
        @ninja.when_receiving(:survive_attack_with).with(@weapon).return(5)

        @weapon.attack(@ninja).should.equal 5

        @ninja.should.have_received?(:survive_attack_with) { |v| v.with(@weapon) }
      end

      it "should fail for expectations with an argument constraint and an assertion argument constraint" do
        ninja = ClrModels::Ninja.new
        @ninja.when_receiving(:survive_attack_with).with(@weapon).return(5)

        @weapon.attack(@ninja).should.equal 5

        @ninja.should.not.have_received?(:survive_attack_with) { |v| v.with(ClrModels::Sword.new) }
      end

      it "should work with an expectation for any arguments" do
        @ninja.when_receiving(:survive_attack_with).return(5)

        result = @weapon.attack @ninja
        result.should.equal 5

        @ninja.should.have_received?(:survive_attack_with) { |v| v.with(:any) }
      end

      it "should work with an assertion for specific arguments" do
        @ninja.when_receiving(:survive_attack_with) do |method_should|
          method_should.return(5)
        end

        result = @weapon.attack @ninja
        result.should.equal 5

        @ninja.should.have_received?(:survive_attack_with) { |v| v.with(@weapon) }
      end

      it "should fail for an assertion with wrong arguments" do
        @ninja.when_receiving(:survive_attack_with) do |method_should|
          method_should.return(5)
        end

        result = @weapon.attack @ninja
        result.should.equal 5

        @ninja.should.not.have_received?(:survive_attack_with) {|v| v.with(isolate(ClrModels::IWeapon)) }
      end

    end

    # describe "that have an indexer" do
    #       before do
    #         @cons = ClrModels::IndexerCaller.new
    #         @ind = Caricature::Isolation.for(ClrModels::IndexerContained)
    #       end
    # 
    #       it "should work without expectations" do
    #         @cons.call_index_on_class(@ind, "key1").should.be.nil
    #       end
    # 
    # 
    #     end
    
  end

  describe "when isolating CLR instances" do

    before do
      @weapon = ClrModels::Sword.new
      @ninja = Caricature::Isolation.for(ClrModels::Ninja.new)
    end

    it "should work without expectations" do
      result = @weapon.attack @ninja
      result.should.equal 0

      @ninja.should.have_received?(:survive_attack_with) { |v| v.with(@weapon) }
    end

    it "should work for expectations with an argument constraint" do
      @ninja.when_receiving(:survive_attack_with).with(@weapon).return(5)

      @weapon.attack(@ninja).should.equal 5

      @ninja.should.have_received?(:survive_attack_with) { |v| v.with(:any) }
    end

    it "should work for expectations with an argument constraint when a wrong argument is passed in" do
      @ninja.when_receiving(:survive_attack_with).with(@weapon).return(5)

      @weapon.attack(ClrModels::Ninja.new).should.equal 6

      @ninja.should.not.have_received?(:survive_attack_with){ |v| v.with(@weapon) }
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

      @ninja.should.have_received?(:survive_attack_with) { |v| v.with(:any) }
    end

    it "should fail for an assertion for specific arguments" do
      @ninja.when_receiving(:survive_attack_with) do |method_should|
        method_should.return(5)
      end

      result = @weapon.attack @ninja
      result.should.equal 5
      @ninja.should.have_received?(:survive_attack_with) { |v| v.with(:any) }
      @ninja.should.have_received?(:survive_attack_with) { |v| v.with(@weapon) }
    end

    it "should allow to delegate the method call to the real instance (partial mock)" do
      @ninja.when_receiving(:survive_attack_with).super_after

      result = @weapon.attack @ninja
      result.should.equal 6

      @ninja.should.have_received?(:survive_attack_with)
    end


  end

end