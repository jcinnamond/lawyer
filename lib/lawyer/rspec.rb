require 'lawyer/rspec/matchers'
require 'lawyer/rspec/contract_double'

RSpec.configure do |config|
  config.include Lawyer::RSpec::Matchers
  config.include Lawyer::RSpec::ContractDouble
end
