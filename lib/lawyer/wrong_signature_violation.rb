module Lawyer
  class WrongSignatureViolation
    def initialize(name, missing:, extra:)
      @name = name
      @missing = missing
      @extra = extra
    end

    def to_s
      details = []
      details << "missing #{@missing}" if @missing.any?
      details << "extra #{@extra}" if @extra.any?
      "\t[wrong signature] #{@name} (#{details.join(', ')})"
    end
  end
end
