require 'rspec/expectations'

module Lawyer
  module RSpec
    module Matchers
      extend ::RSpec::Matchers::DSL

      matcher :implement do |contract|
        match do |implementation|
          begin
            contract.check!(implementation)
            true
          rescue Lawyer::BrokenContract => e
            @exception = e
            false
          end
        end

        failure_message do |actual|
          @exception.to_s
        end
      end
    end
  end
end
