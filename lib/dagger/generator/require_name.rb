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
        string = dictionary['_meta.name']
        enumerable(regexps).any? do |regexp|
          ::Regexp.new(regexp).match?(string)
        end
      end
    end
  end
end
