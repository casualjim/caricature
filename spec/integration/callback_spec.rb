require File.dirname(__FILE__) + "/../bacon_helper"

describe "Callbacks on expectations" do
  
  describe "CLR to CLR interactions" do
  
    describe "when isolating CLR interfaces" do
    
      before do
        @ninja = ClrModels::Ninja.new
        @weapon = Caricature::Isolation.for(ClrModels::IWeapon)
      end   
      
      it "should execute the callback when the expectation is invoked" do 
        ninja = ClrModels::Ninja.new   
        cnt = 0
        @weapon.when_receiving(:attack).with(:any) do |*args|
          cnt += 1
        end  
        @ninja.attack ninja, @weapon
        
        cnt.should == 1
      end
  
    end   
    
    describe "when isolating CLR classes" do
          
      before do
        @ninja = ClrModels::Ninja.new
        @weapon = Caricature::Isolation.for(ClrModels::Sword)
      end   
      
      it "should execute the callback when the expectation is invoked" do 
        ninja = ClrModels::Ninja.new   
        cnt = 0
        @weapon.when_receiving(:attack).with(:any) do |*args|
          cnt += 1
        end 
        @ninja.attack ninja, @weapon
        
        cnt.should == 1
      end
      
    end                                 
    
    describe "when isolating CLR instances" do
      before do
        @ninja = ClrModels::Ninja.new
        @weapon = Caricature::Isolation.for(ClrModels::Sword.new)
      end   
      
      it "should execute the callback when the expectation is invoked" do 
        ninja = ClrModels::Ninja.new   
        cnt = 0
        @weapon.when_receiving(:attack).with(ninja) do |*args|
          cnt += 1
        end 
        @ninja.attack ninja, @weapon
        
        cnt.should == 1
      end
    end    
  
  end  
  
  describe "CLR to ruby interactions" do
    
    describe "when isolating CLR interfaces" do
    
      before do
        @ninja = Soldier.new
        @weapon = Caricature::Isolation.for(ClrModels::IWeapon)
      end   
      
      it "should execute the callback when the expectation is invoked" do 
        ninja = Soldier.new   
        cnt = 0
        @weapon.when_receiving(:attack).with(:any) do |*args|
          cnt += 1
        end  
        @ninja.attack ninja, @weapon
        
        cnt.should == 1
      end
  
    end   
    
    describe "when isolating CLR classes" do
          
      before do
        @ninja = Soldier.new
        @weapon = Caricature::Isolation.for(ClrModels::Sword)
      end   
      
      it "should execute the callback when the expectation is invoked" do 
        ninja = Soldier.new  
        cnt = 0
        @weapon.when_receiving(:attack).with(:any) do |*args|
          cnt += 1
        end 
        @ninja.attack ninja, @weapon
        
        cnt.should == 1
      end
      
    end                                 
    
    describe "when isolating CLR instances" do
      before do
        @ninja = Soldier.new
        @weapon = Caricature::Isolation.for(ClrModels::Sword.new)
      end   
      
      it "should execute the callback when the expectation is invoked" do 
        ninja = Soldier.new   
        cnt = 0
        @weapon.when_receiving(:attack).with(ninja) do |*args|
          cnt += 1
        end 
        @ninja.attack ninja, @weapon
        
        cnt.should == 1
      end
    end    
  
    
  end    
  
  describe "Ruby to Ruby interactions" do
    
    it "should execute a callback when an expectation is being invoked and with is not defined in a block" do
      iso = Caricature::Isolation.for(Dagger)         
      cnt = 0
      iso.when_receiving(:damage).with(:any) do |*args|
         cnt += 1
      end 
      iso.damage       
      cnt.should == 1
    end   
    
    it "should execute a callback when an expectation is being invoked and with is defined in a block" do
      cnt = 0
      iso = Caricature::Isolation.for(Dagger) 
      iso.when_receiving(:damage) do |exp| 
        exp.with(:any) do |*args|
           cnt += 1
        end
      end  
      iso.damage       
      cnt.should == 1
    end
  end


  
end