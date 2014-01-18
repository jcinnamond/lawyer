# Lawyer

Strong Duck Typing for Ruby.

Lawyer allows you to create contracts that specify how an object behaves.

	require 'lawyer'

	class Pingable < Lawyer::Contract
	  contains :ping
	end

You can then ensure that your class implements the contract.

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


...and then check that the arguments passed to a method match some interface:

	require 'pingable'

	class PingServer
	  def initialize(client)
	    Pingable.check(client)

	    # If you get this far then you know you can safely call
		client.ping
	  end
	end

...or even force your methods to only use a declared interface:

	require 'pingable'

	class ParanoidPingServer
	  def initialize(client)
	    pingable_client = Pingable.proxy(client)

	    # pingable_client only responds to the methods in Pingable
		pingable_client.ping
		pingable_client.pong # => NoMethodError
	  end
	end

...and add it to your tests:

    describe PingServer do
	  describe ".new" do
	    it "checks that the client is pingable" do
		  expect(PingServer, :new).to check_interface(Pingable)
		end
	  end
	end

...and use mocks to test your code:

	describe PingServer do
	  let(:pinger) { interface_double(Pingable) }
	  subject(:server) { PingServer.new(pinger) }

	  it "pings" do
	    server.run
		expect(pinger).to have_received(:ping)
	  end
	end

This helps you to write loosely coupled code that relies on well defined interfaces.
By declaring that a class implements a given interface you catch any mismatch between
the expected behaviour and the implementation when the file is required, instead of
encountering a runtime error when it's too late. Combining this with argument checking
and testing those through rspec will give you confidence that changing one part of the
code (i.e., the interface, the implementation of the interface or the consumer) will
not break other parts.

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
	  class HttpClient < Lawyer::Contract
	    contains :get => [:url]
		contains :post => [:url, :data]
	  end
	end

Then write an implementation of it and declare that it implements the interface:

	require 'net/http'

	class NativeHttpClient
	  def get(:url)

	  end
	end

## Contributing

1. Fork it ( http://github.com/jcinnamond/lawyer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
