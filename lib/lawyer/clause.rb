require 'lawyer/method_missing_violation'
require 'lawyer/wrong_arity_violation'
require 'lawyer/wrong_signature_violation'

module Lawyer
  class Clause
    attr_reader :name, :arity, :signature

    def initialize(params)
      @arity = nil
      @signature = nil

      if params.is_a?(Hash)
        (@name, details) = params.first
        case details
        when Fixnum
          @arity = details
        when Array
          @signature = details
        end
      else
        @name = params.to_sym
      end
    end

    def check(subject)
      if missing_method?(subject)
        Lawyer::MethodMissingViolation.new(@name)
      elsif wrong_arity?(subject)
        Lawyer::WrongArityViolation.new(@name, expected: @arity, actual: actual_arity(subject))
      elsif wrong_signature?(subject)
        Lawyer::WrongSignatureViolation.new(@name,
          missing: missing_parameters(subject),
          extra: extra_parameters(subject))
      else
        nil
      end
    end

    def missing_method?(subject)
      (@name != :initialize) && !subject.instance_methods.include?(@name)
    end

    def wrong_arity?(subject)
      @arity && @arity != actual_arity(subject)
    end

    def actual_arity(subject)
      method_from(subject).arity
    end

    def wrong_signature?(subject)
      @signature && (missing_parameters(subject).any? || extra_parameters(subject).any?)
    end

    def missing_parameters(subject)
      @signature - actual_signature(subject)
    end

    def extra_parameters(subject)
      actual_signature(subject) - @signature
    end

    def actual_signature(subject)
      method_from(subject).parameters.select { |p| p[0] == :keyreq }.map(&:last) || []
    end

    def method_from(subject)
      subject.instance_method(@name)
    end
  end
end
