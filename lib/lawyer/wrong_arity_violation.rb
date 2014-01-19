module Lawyer
  class WrongArityViolation
    def initialize(name, expected:, actual:)
      @name = name
      @expected = expected
      @actual = actual
    end

    def to_s
      "\t[wrong arity] #{@name} (takes #{@actual}, requires #{@expected})"
    end
  end
end
