# frozen_string_literal: true

require_relative '../generator'

module Dagger
  module Generate
    # Generate a value for a +string+ rule.
    #
    # _default.key:
    #   - string: "format string"
    #   - string:
    #       - "format string"
    #       - ...
    class String < Dagger::Generator
      def process(strings)
        enumerable(strings).each do |fmtstr|
          result = format_string(fmtstr)
          yield result unless result.nil?
        end
      end
    end
  end
end
