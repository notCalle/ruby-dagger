require_relative '../generator'

module Dagger
  module Generate
    # Generate a value by collecting regexp matches for keys,
    # and filling format strings.
    #
    # _default.key:
    #   - regexp:
    #       srckey:
    #         - regexp
    #         - ...
    #       ...
    #     string:
    #       - format string
    #       - ...
    class Regexp < Dagger::Generator
      def yield(sources)
        matches = {}
        sources.each do |key, regexps|
          matches.merge!(match_regexps(key, regexps))
        end
        update(dictionary: matches)
      end

      private

      # Match the value of a key agains regexps, returning the named
      # captured data.
      #
      # :call-seq:
      #   match_regexps(key, regexps) => Hash
      def match_regexps(key, regexps)
        string = dictionary[key]

        enumerable(regexps).each_with_object({}) do |regexp, matches|
          matchdata = ::Regexp.new(regexp).match(string)
          next if matchdata.nil?
          matches.merge!(matchdata.named_captures.transform_keys(&:to_sym))
        end
      end
    end
  end
end
