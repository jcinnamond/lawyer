module Lawyer
  module RSpec
    module ContractDouble
      def contract_double(contracts, return_values = {})
        contracts = [contracts] unless contracts.is_a?(Enumerable)
        double_name = contracts.map(&:name).join(", ")
        the_double = double(double_name)

        contracts.each do |contract|
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
              receiver.with(clause.signature.inject({}) do |acc, name|
                  acc[name] = anything
                  acc
                end)
            end
          end
        end
        the_double
      end
    end
  end
end
