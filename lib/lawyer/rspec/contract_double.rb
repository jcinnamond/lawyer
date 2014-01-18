module Lawyer
  module RSpec
    module ContractDouble
      def contract_double(contract)
        methods = {}
        contract.clauses.each do |clause|
          methods[clause.name] = true
        end
        double(contract.name, methods)
      end
    end
  end
end
