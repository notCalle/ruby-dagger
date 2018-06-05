# frozen_string_literal: true

require_relative '../generator'

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
    class Integer < Numeric
      def process(strings, &yielder)
        super(string, :to_i, &yielder)
      end
    end
  end
end
