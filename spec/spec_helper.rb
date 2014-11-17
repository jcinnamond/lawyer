require 'lawyer'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end
