Caricature - Bringing simple mocking to the DLR
===============================================

This project aims to make interop between IronRuby objects and .NET objects easier.
The idea is that it integrates nicely with bacon and later rspec and that it transparently lets you mock ironruby ojbects
as well as CLR objects/interfaces.
Caricature handles interfaces, interface inheritance, CLR objects, CLR object instances, Ruby classes and instances of Ruby classes.

From the start I wanted to do away with names like mock, stub, record, replay, verify etc.
Instead I took the advice from Roy Osherhove and went with a name of Isolation for creating a mock.

An Isolation will create what in Rhino.Mocks would be called a DynamicMock (but can be a partial too) :)
In Moq it would be the Loose mocking strategy.

The naming of the methods for creating mocks is the one that JP Boodhoo proposed WhenToldTo and WasToldTo.
To specify a stub/expectation on a mock you have one and only one way of doing that with the method called when_told_to.
Then only if you're interested in asserting if a method has been called you can use the was_told_to? method for this.

<pre>
mock = Isolation.for(Ninja)
mock.when_told_to(:attack) do |exp|
  exp.with(:shuriken)
  exp.return(3)
end

Battle.new(mock)
battle.combat

mock.was_told_to?(:attack).should.be.successful
</pre>