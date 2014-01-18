require 'lawyer/method_missing_violation'

module Lawyer
  class Clause
    attr_reader :name

    def initialize(details)
      @name = details.to_sym
    end

    def check(subject)
      if missing_method?(subject)
        Lawyer::MethodMissingViolation.new(@name)
      else
        nil
      end
    end

    def missing_method?(subject)
      !subject.instance_methods.include?(@name)
    end
  end
end
