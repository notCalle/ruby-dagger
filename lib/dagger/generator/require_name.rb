# frozen_string_literal: true

require_relative '../generator'

module Dagger
  module Generate
    # Set requirement for further processing.
    #
    # _default.key:
    #   - require_name: regexp
    #   - ...
    class RequireName < Dagger::Generator
      def process(regexps)
        stop unless enumerable(regexps).any? do |regexp|
          ::Regexp.new(regexp).match?(vertex.name)
        end
      end
    end
  end
end
