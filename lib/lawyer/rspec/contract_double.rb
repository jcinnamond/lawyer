module Lawyer
  module RSpec
    module ContractDouble
      def contract_double(contract, return_values = {})
        the_double = double(contract.name)

        contract.clauses.each do |clause|
          next if clause.name.to_sym == :initialize

          return_value = if return_values.has_key?(clause.name.to_sym)
                           return_values[clause.name.to_sym]
                         else
                           true
                         end

          receiver = allow(the_double).to receive(clause.name).and_return(return_value)
          if clause.arity
            receiver.with(*clause.arity.times.map { anything })
          elsif clause.signature
            receiver.with(clause.signature.inject({}) { |acc, name| acc[name] = anything; acc })
          end
        end
        the_double
      end
    end
  end
end
