require 'lawyer/rspec'

class DoublableContract < Lawyer::Contract
  confirm :ping
  confirm :arity => 2
  confirm :named => [:arg, :arg2]
end

describe Lawyer::RSpec::ContractDouble do
  include Lawyer::RSpec::ContractDouble

  subject(:the_double) { contract_double(DoublableContract)  }

  it { should be_a(RSpec::Mocks::Mock) }
  it { should respond_to(:ping) }
  it { should_not respond_to(:pong) }

  it "checks method arity" do
    expect { the_double.arity(1) }.to raise_error(RSpec::Mocks::MockExpectationError)
  end

  it "checks named arguments" do
    expect { the_double.named }.to raise_error(RSpec::Mocks::MockExpectationError)
  end
end
