# frozen_string_literal: true

require_relative '../generator'

module Dagger
  module Generate
    # Generate a floating point value from a format string
    #
    # _default.key:
    #   - float: "#{key}"
    #   - float:
    #     - "#{key}"
    #     - ...
    class Float < Numeric
      def process(strings, &yielder)
        super(strings, :to_f, &yielder)
      end
    end
  end
end
