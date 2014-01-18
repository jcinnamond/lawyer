module Lawyer
  class MethodMissingViolation
    def initialize(name)
      @name = name
    end

    def to_s
      "\t[missing] #{@name}"
    end
  end
end
