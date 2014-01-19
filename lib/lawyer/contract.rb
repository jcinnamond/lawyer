require 'lawyer/clause'

module Lawyer
  class Contract
    class << self
      def clauses
        @clauses ||= []
      end

      def confirm(clause)
        self.clauses << Lawyer::Clause.new(clause)
      end

      def check!(subject)
        klass = subject.is_a?(Class) ? subject : subject.class

        violations = self.clauses.map do |clause|
          clause.check(klass)
        end
        violations.compact!

        if violations.any?
          raise Lawyer::BrokenContract.new(klass, self, violations)
        end
      end
    end
  end
end
