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
      def process(strings, &yielder)
        super(strings, :to_i, &yielder)
      end
    end
  end
end
