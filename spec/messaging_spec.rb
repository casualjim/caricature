require File.dirname(__FILE__) + "/bacon_helper"

class EmptyExpectations
  def find(method_name, *args, &b)
    nil
  end
end

class ReturnValueExpecation

  def initialize
    @super_before_called = false
    @call_super_called = false
    @called_super_after = false
  end

  def super_before?
    @super_before_called = true
    false
  end

  def call_super?
    @call_super_called = true
    false
  end

  def have_called_super_before?
    @super_before_called
  end

  def have_called_call_super?
    @super_before_called && @called_super_after
  end

  def execute(*args)
    @called_super_after = !@call_super_called
    5
  end
end

class ReturnValueExpectations
  def expectation
    @expectation ||= ReturnValueExpecation.new
    @expectation
  end
  def find(method_name, *args, &b)
    return expectation  if method_name == :a_message
    nil
  end
end

describe "Caricature::Messenger strategies" do

  describe "Caricature::RubyMessenger" do

    it "should return nil for any method name not in the expectation collection" do
      messenger = Caricature::RubyMessenger.new EmptyExpectations.new
      messenger.deliver(:a_message, nil).should.be.nil
    end

    describe "when an expectation with a return value has been defined" do

      before do
        @messenger = Caricature::RubyMessenger.new ReturnValueExpectations.new
      end

      it "should return the a value when specified by the expecation" do
        @messenger.deliver(:a_message, nil).should.not.be.nil
      end

      it "should return the value specified by the expecation" do
        @messenger.deliver(:a_message, nil).should.equal 5
      end

      it "should call super_before before executing the expectation" do
        @messenger.deliver(:a_message, nil)
        @messenger.expectations.expectation.should.have_called_super_before
      end

      it "should call call_super? after executing the expectation" do
        @messenger.deliver(:a_message, nil)
        @messenger.expectations.expectation.should.have_called_call_super
      end

    end




  end

  describe "Caricature::ClrClassMessenger" do

    it "should return nil for any method name not in the expectation collection" do
      messenger = Caricature::ClrClassMessenger.new EmptyExpectations.new
      messenger.deliver(:a_message, nil).should.be.nil
    end

    it "should return the default value for a value type return type" do
      messenger = Caricature::ClrClassMessenger.new EmptyExpectations.new
      messenger.deliver(:a_message, System::Int32.to_clr_type).should.equal 0
    end

    describe "when an expectation with a return value has been defined" do

      before do
        @messenger = Caricature::ClrClassMessenger.new ReturnValueExpectations.new
      end

      it "should return the a value when specified by the expecation" do
        @messenger.deliver(:a_message, nil).should.not.be.nil
      end

      it "should return the value specified by the expecation" do
        @messenger.deliver(:a_message, nil).should.equal 5
      end

      it "should call super_before before executing the expectation" do
        @messenger.deliver(:a_message, nil)
        @messenger.expectations.expectation.should.have_called_super_before
      end

      it "should call call_super? after executing the expectation" do
        @messenger.deliver(:a_message, nil)
        @messenger.expectations.expectation.should.have_called_call_super
      end

    end

  end

  describe "Caricature::ClrInterfaceMessenger" do

    it "should return nil for any method name not in the expectation collection" do
      messenger = Caricature::ClrInterfaceMessenger.new EmptyExpectations.new
      messenger.deliver(:a_message, nil).should.be.nil
    end

    it "should return the default value for a value type return type" do
      messenger = Caricature::ClrClassMessenger.new EmptyExpectations.new
      messenger.deliver(:a_message, System::Int32.to_clr_type).should.equal 0
    end

    describe "when an expectation with a return value has been defined" do

      before do
        @messenger = Caricature::ClrInterfaceMessenger.new ReturnValueExpectations.new
      end

      it "should return the a value when specified by the expecation" do
        @messenger.deliver(:a_message, nil).should.not.be.nil
      end

      it "should return the value specified by the expecation" do
        @messenger.deliver(:a_message, nil).should.equal 5
      end

      it "should not call super_before before executing the expectation" do
        @messenger.deliver(:a_message, nil)
        @messenger.expectations.expectation.should.not.have_called_super_before
      end

      it "should not call call_super? after executing the expectation" do
        @messenger.deliver(:a_message, nil)
        @messenger.expectations.expectation.should.not.have_called_call_super
      end

    end

  end

end