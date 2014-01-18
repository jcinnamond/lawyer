require 'lawyer/rspec'

class DoublableContract < Lawyer::Contract
  confirm :ping
end

describe Lawyer::RSpec::ContractDouble do
  include Lawyer::RSpec::ContractDouble

  subject { contract_double(DoublableContract)  }

  it { should be_a(RSpec::Mocks::Mock) }
  it { should respond_to(:ping) }
  it { should_not respond_to(:pong) }
end
