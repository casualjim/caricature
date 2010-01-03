require File.dirname(__FILE__) + "/../spec_helper"

describe "CLR to CLR interactions" do

  describe "when isolating CLR classes" do

    describe "that have an indexer" do
      before do
        @cons = ClrModels::IndexerCaller.new
        @ind = Caricature::Isolation.for(ClrModels::IndexerContained)
      end

      it "should work without expectations" do
        @cons.call_index_on_class(@ind, "key1").should be_nil
      end

      it "should work with an expectation" do
        @ind.when_receiving(:Item).return("5")
        
        @cons.call_index_on_class(@ind, "key1").should == "5"
      end


    end

  end

end