# Lawyer

Strong Duck Typing for Ruby.

Lawyer allows you to create contracts that specify how an object behaves.

	require 'lawyer'

	class Pingable < Lawyer::Contract
	  confirm :ping
	end

You can then ensure that your class implements the contract:

	require 'pingable'

    class Foo
	  def ping
	    puts "ping"
	  end

	  def pong
	    puts "pong"
	  end
	end

	Foo.implements(Pingable)

...but this works best when you write loosely coupled objects and then define the
interfaces between them. You can then write specs to check that a class implements
a particular contract:

    require 'foo'
	require 'pingable'

	describe Foo do
	  it { should implement(Pingable) }
	end

...and use mocks to test methods that expect to receive objects that conform to
a particular contract:

	describe Pinger do
	  let(:pingable) { contract_double(Pingable) }
	  subject(:pinger) { Pinger.new(pingable) }

	  it "pings the pingable" do
	    subject.run
		expect(:pingable).to have_received(:ping)
	  end

      it "can't call methods that aren't part of the contract" do
	    expect { pingable.pong }.to raise_error(NoMethodError)
	  end
	end

...all based off a single definition of the contract.

This helps you to write loosely coupled code that relies on well defined interfaces.
By declaring the contract up front and then using that in your tests you can ensure
that any mismatches between the expected interface and the actual impelmentations are
caught as you modify your codebase.

## Installation

Add this line to your application's Gemfile:

    gem 'lawyer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install laywer

## Usage

First up, create a contract that specifies the methods available in an interface:

    require 'lawyer'

	module Contracts
	  class Person < Lawyer::Contract
	    check :name                               # check that the method exists
		check :name= => 1                         # check the method arity
		check :rename => [:firstname, :lastname]  # check required named parameters (ruby 2.1 only)
	  end
	end


Add Laywer to your spec_helper by including:

	require 'lawyer/rspec'

Test an implementation:

    require 'contracts/person'
	require 'person_record'

	describe PersonRecord do
	  it { should implement(Contracts::Person) }

      # test the implementation
	end

And test a receiver:

    require 'contracts/person'
	require 'namer'

    describe Namer do
	  let(:person) { contract_double(Contracts::Person) }
	  subject(:namer) { Namer.new(person) }

      it "sets the name" do
	    expect(person).to receive(:name=).with("John Smith")
		namer.set_name("John Smith")
	  end
	end

## Credits

Many thanks to Jakub Oboza (http://lambdacu.be) for suggesting an original
implementation of this idea and for discussing the motivations behind it.

## Contributing

1. Fork it ( http://github.com/jcinnamond/lawyer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
