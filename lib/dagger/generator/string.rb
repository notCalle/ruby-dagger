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
      def yield(strings)
        enumerable(strings).each do |fmtstr|
          result = format_string(fmtstr, dictionary)
          yield result unless result.nil?
        end
      end

      private

      # Format a +string+ with values from a +dictionary+
      #
      # :call-seq:
      #   format_string(string, dictionary)
      def format_string(string, dictionary)
        Kernel.format(string, Hash.new { |_, key| dictionary[key] })
      rescue KeyError
        nil
      end
    end
  end
end
