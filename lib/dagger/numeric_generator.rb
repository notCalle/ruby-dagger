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
    end
  end
end
