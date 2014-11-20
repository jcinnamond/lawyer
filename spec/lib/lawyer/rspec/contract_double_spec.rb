require 'lawyer/rspec'

class DoublableContract < Lawyer::Contract
  confirm :ping
  confirm :arity => 2
  confirm :named => [:arg, :arg2]
end

RSpec.describe Lawyer::RSpec::ContractDouble do
  include Lawyer::RSpec::ContractDouble

  subject(:the_double) { contract_double(DoublableContract) }

  it { should be_a(RSpec::Mocks::Double) }
  it { should respond_to(:ping) }
  it { should_not respond_to(:pong) }

  it "checks method arity" do
    expect { the_double.arity(1) }.to raise_error(RSpec::Mocks::MockExpectationError)
    expect { the_double.arity(1, 2) }.not_to raise_error
  end

  it "checks named arguments" do
    expect { the_double.named }.to raise_error(RSpec::Mocks::MockExpectationError)
    expect { the_double.named(arg: 1, arg2: 2) }.not_to raise_error
  end
end
