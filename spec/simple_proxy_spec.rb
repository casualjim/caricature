require File.dirname(__FILE__) + "/bacon_helper"
require File.dirname(__FILE__) + "/../lib/caricature/simple_proxy"

class Soldier

  def name
    "Tommy Boy"
  end

  def to_s
    "I'm a soldier"
  end

end

describe "SimpleProxy" do

  before do
    @subj = Soldier.new
    @prxy = SimpleProxy.new(@subj)
  end

  it "should forward existing methods" do
    @prxy.name.should.equal @subj.name
  end

  it "should call to_s on the proxied object" do
    @prxy.to_s.should.equal @subj.to_s    
  end
end