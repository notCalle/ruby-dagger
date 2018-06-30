# frozen_string_literal: true

require_relative 'generator'

module Dagger
  module Generate
    # Abstract base for generating numeric values
    class NumericGenerator < Dagger::Generator
      def process(args)
        enumerable(args).each do |arg|
          result = process_recurse(arg)
          yield result unless result.nil?
        end
      end

      private

      def process_recurse(arg)
        case arg
        when Hash
          process_hash(arg)
        when ::String
          str = format_string(arg)
          from_s(str) unless str.nil?
        else
          from_s(arg)
        end
      end

      def process_hash(hash)
        hash.each do |key, args|
          args = enumerable(args).map { |arg| process_recurse(arg) }
          result = send("numeric_#{key}", args.delete(nil))
          return result unless result.nil?
        end
      end

      def numeric_sum(args)
        args.sum
      end

      def numeric_product(args)
        args.reduce(:*)
      end

      def numeric_arithmetic_mean(args)
        return if args.empty?
        numeric_sum(args) / args.length
      end

      def numeric_geometric_mean(args)
        return if args.empty?
        numeric_product(args)**(1.0 / args.length)
      end

      def numeric_harmonic_mean(args)
        return if args.empty?
        args.length / args.map { |n| 1.0 / n }.sum
      end
    end
  end
end
