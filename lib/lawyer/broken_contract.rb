module Lawyer
  class BrokenContract < StandardError
    def initialize(subject, contract, violations)
      @subject = subject.name
      @contract = contract.name
      @method_missing_violations = violations
    end

    def to_s
      str = "#{@subject} does not implement <#{@contract}>\n"
      if @method_missing_violations.any?
        count = @method_missing_violations.count
        str << "\t(#{count} missing #{pluralize('method', count)})\n"
        str << @method_missing_violations.map(&:to_s).join("\n")
        str << "\n"
      end
      str
    end

    def pluralize(str, count)
      str
    end
  end
end
