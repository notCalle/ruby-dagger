# frozen_string_literal: true

require_relative 'generator'

module Dagger
  module Generate
    # Abstract base for generating numeric values
    class NumericGenerator < Dagger::Generator
      def process(strings, to_num)
        enumerable(strings).each do |fmtstr|
          result = format_string(fmtstr)
          yield to_num.to_proc.call(result) unless result.nil?
        end
      end
    end
  end
end
