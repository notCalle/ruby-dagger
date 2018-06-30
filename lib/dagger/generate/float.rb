# frozen_string_literal: true

require_relative '../numeric_generator'

module Dagger
  module Generate
    # Generate a floating point value from a format string
    #
    # _default.key:
    #   - float: "#{key}"
    #   - float:
    #     - "#{key}"
    #     - ...
    class Float < NumericGenerator
      private

      def from_s(string)
        string.to_f
      end
    end
  end
end
