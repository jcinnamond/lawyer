module Lawyer
  module RSpec
    module ContractDouble
      def contract_double(contract, return_values = {})
        methods = {}
        contract.clauses.each do |clause|
          next if clause.name.to_sym == :initialize

          return_value = if return_values.has_key?(clause.name.to_sym)
                           return_values[clause.name.to_sym]
                         else
                           true
                         end
          methods[clause.name] = return_value
        end
        double(contract.name, methods)
      end
    end
  end
end
