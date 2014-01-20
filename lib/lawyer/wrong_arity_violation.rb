module Lawyer
  class WrongArityViolation
    def initialize(name, expected: 0, actual: 0)
      @name = name
      @expected = expected
      @actual = actual
    end

    def to_s
      "\t[wrong arity] #{@name} (takes #{@actual}, requires #{@expected})"
    end
  end
end
