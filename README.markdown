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
To specify a stub/expectation on an isolation you have one and only one way of doing that with the method called when_receiving.
Then only if you're interested in asserting if a method has been called you can use the did_receive? method for this.
                                                   

    isolation = Isolation.for(Ninja)
    isolation.when_receiving(:attack) do |exp|
    exp.with(:shuriken)
    exp.return(3)
    end

    Battle.new(mock)
    battle.combat

    isolation.did_receive?(:attack).should.be.successful


It may be very important to note that when you're going to be isolating CLR classes to be used in other CLR classes
you still need to obide by the CLR rules. That means if you want to redefine a method you'll need to make sure it's
marked as virtual. Static types are still governed by static type rules.  I'm working on a solution around those
problems but for the time being this is how it has to be.

License:
--------

 Caricature -- A simple mocking framework for IronRuby

 Copyright (c) 2009, Caricature Team
 http://github.com/casualjim/caricature
 All rights reserved.

 Redistribution and use in source and binary forms,
 with or without modification, are permitted provided
 that the following conditions are met:

    * Redistributions of source code must retain the
    above copyright notice, this list of conditions and
    the following disclaimer.

    * Redistributions in binary form must reproduce
    the above copyright notice, this list of conditions
    and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

    * Neither the name of the Caricature Team nor the
    names of its contributors may be used to endorse
    or promote products derived from this software
    without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.

 [This is the BSD license, see
  http://www.opensource.org/licenses/bsd-license.php]