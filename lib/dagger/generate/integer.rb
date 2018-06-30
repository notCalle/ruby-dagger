# frozen_string_literal: true

require_relative '../numeric_generator'

module Dagger
  module Generate
    # Generate an integer value from a format string
    #
    # _default.key:
    #   - integer: "#{key}"
    #   - integer:
    #     - "#{key}"
    #     - ...
    #   - integer:
    #       accumulate:
    class Integer < NumericGenerator
      private

      def from_s(string)
        string.to_i
      end
    end
  end
end
