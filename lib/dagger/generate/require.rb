# frozen_string_literal: true

require_relative '../generator'

module Dagger
  module Generate
    # Set requirement for further processing.
    #
    # _default.key:
    #   - require:
    #       key: regexp
    #   - ...
    class Require < Dagger::Generator
      def process(keys)
        stop unless keys.any? do |key, regexps|
          string = @context.dictionary[key]
          array(regexps).any? do |regexp|
            ::Regexp.new(regexp).match?(string)
          end
        end
      end
    end
  end
end
