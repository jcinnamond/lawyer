require 'lawyer/method_missing_violation'
require 'lawyer/wrong_arity_violation'

module Lawyer
  class Clause
    attr_reader :name

    def initialize(params)
      if params.is_a?(Hash)
        (@name, details) = params.first
        @arity = details
      else
        @name = params.to_sym
        @arity = nil
      end
    end

    def check(subject)
      if missing_method?(subject)
        Lawyer::MethodMissingViolation.new(@name)
      elsif wrong_arity?(subject)
        Lawyer::WrongArityViolation.new(@name, expected: @arity, actual: actual_arity(subject))
      else
        nil
      end
    end

    def missing_method?(subject)
      !subject.instance_methods.include?(@name)
    end

    def wrong_arity?(subject)
      @arity && @arity != actual_arity(subject)
    end

    def actual_arity(subject)
      method_from(subject).arity
    end

    def method_from(subject)
      subject.instance_method(@name)
    end
  end
end
