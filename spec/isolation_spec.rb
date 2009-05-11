# Caricature -- A simple mocking framework for IronRuby
#
# Copyright (c) 2009, Caricature Team
# http://github.com/casualjim/caricature
# All rights reserved.
#
# Redistribution and use in source and binary forms,
# with or without modification, are permitted provided
# that the following conditions are met:
#
#    * Redistributions of source code must retain the
#    above copyright notice, this list of conditions and
#    the following disclaimer.
#
#    * Redistributions in binary form must reproduce
#    the above copyright notice, this list of conditions
#    and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
#    * Neither the name of the Caricature Team nor the
#    names of its contributors may be used to endorse
#    or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
# [This is the BSD license, see
#  http://www.opensource.org/licenses/bsd-license.php]

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
      @isolator.proxy.should.not.be == nil
    end

    it "should create the Ruby objects proxy" do
      @isolator.proxy.is_clr_proxy?.should.be.false?
    end

    describe "when asked to stub a method" do

      it "should create an expectation" do
        nm = "What's in a name"
        expectation = @isolator.when_told_to(:name) do |cl|
          cl.return(nm)
        end
        expectation.method_name.should.equal :name
        expectation.has_return_value?.should.be.true?
        expectation.return_value.should.equal nm
      end
    end

  end

  describe 'when verifying if a call was made' do

    before do
      @rec = Caricature::MethodCallRecorder.new
      @rec.record_call :my_method
      @rec.record_call :my_method, 1, 2, 3
      @proxy = Caricature::RecordingProxy.new(Soldier, @rec)
    end

    it "should be successful with any arguments allowed" do
      iso = Caricature::Isolation.new(@proxy, @rec)
      iso.was_told_to?(:my_method).should.be.true?
    end

    it "should be successful with a correct set of arguments provided for my_method" do
      iso = Caricature::Isolation.new(@proxy, @rec)
      iso.was_told_to?(:my_method){ |ver| ver.with(1, 2, 3) }.should.be.true?
    end

    it "should be unsuccessful when a wrong set of arguments is provided" do
      iso = Caricature::Isolation.new(@proxy, @rec)
      iso.was_told_to?(:my_method){|ver| ver.with(1, 3, 6) }.should.be.false?
    end

    it "should be unsuccessful when the wrong method name is provided" do
      iso = Caricature::Isolation.new(@proxy, @rec)
      iso.was_told_to?(:some_method).should.be.false?
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
      @isolator.proxy.should.not.be == nil
    end

    it "should create the CLR objects proxy" do
      @isolator.proxy.is_clr_proxy?.should.be.true?
    end

  end

end