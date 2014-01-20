module Lawyer
  class BrokenContract < StandardError
    def initialize(subject, contract, violations)
      @subject = subject.name
      @contract = contract.name
      @method_missing_violations = violations.select { |v| v.is_a?(MethodMissingViolation) }
      @wrong_arity_violations = violations.select { |v| v.is_a?(WrongArityViolation) }
      @wrong_signature_violations = violations.select { |v| v.is_a?(WrongSignatureViolation) }
    end

    def to_s
      str = "#{@subject} does not implement <#{@contract}>\n"
      str << explain_violations(@method_missing_violations, "missing")
      str << "\n" if @method_missing_violations.any? &&
                    (@wrong_arity_violations/any? || @wrong_signature_violations.any?)
      str << explain_violations(@wrong_arity_violations, "with the wrong arity")
      str << "\n" if (@method_missing_violations.any? || @wrong_arity_violations.any?) &&
                     @wrong_signature_violations.any?
      str << explain_violations(@wrong_signature_violations, "with the wrong signature")
      str
    end

    def explain_violations(violations, type)
      str = ""
      if violations.any?
        count = violations.count
        str << "\t(#{count} #{methods(count)} #{type})\n"
        str << violations.map(&:to_s).join("\n")
        str << "\n"
      end
      str
    end

    def methods(count)
      count == 1 ? "method" : "methods"
    end
  end
end
