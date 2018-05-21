require 'set'

module Dagger
  # Default value generator for a dictionary
  class Default
    KeyPath = KeyTree::Path

    # Initialize a default value generator for a +dictionary+
    #
    # :call-seq:
    #   new(dictionary) => Dagger::Default
    #   new(*, cached: false)
    #   new(*, rule_prefix: '_default')
    def initialize(dictionary, cached: false, rule_prefix: '_default')
      @dictionary = dictionary
      @cached = cached
      @rule_prefix = KeyPath[rule_prefix]
      @locks = Set[]
      @default_proc = ->(tree, key) { generate(tree, key) }
    end

    attr_reader :default_proc

    # Verify state of caching of future values
    #
    # :call-seq:
    #   cached? => bool
    def cached?
      !(!@cached)
    end
    attr_writer :cached

    # Generate a default value for a +key+, possibly caching the
    # result in the +tree+.
    # Raises a +KeyError+ f the default value cannot be generated.
    #
    # :call-seq:
    #   generate(tree, key) => value || KeyError
    def generate(tree, key)
      key = KeyPath[key] unless key.is_a? KeyPath
      raise %(deadlock detected: "#{key}") unless @locks.add?(key)

      return result = generate_value(key) unless cached?
      tree[key] = result
    ensure
      @locks.delete(key)
    end

    protected

    # Generate a value for a +string+ rule.
    #
    # _default.key:
    #   - string: "format string"
    #   - string:
    #       - "format string"
    #       - ...
    #
    # :call-seq:
    #   generate_value_for_string(string: data)
    #
    # Throws +:result+ or raises +KeyError+
    def generate_value_for_string(dictionary = @dictionary, string:)
      enumerable(string).each do |fmtstr|
        result = format_string(fmtstr, dictionary)
        throw :result, result unless result.nil?
      end
    end

    # Set requirement for further processing.
    #
    # _default.key:
    #   - require:
    #       key: regexp
    #   - ...
    #
    # :call-seq:
    #   generate_value_for_require(require:)
    def generate_value_for_require(require:)
      throw :abort unless require.all? do |key, regexps|
        string = @dictionary[key]
        enumerable(regexps).any? do |regexp|
          Regexp.new(regexp).match?(string)
        end
      end
    end

    private

    # Generate the default value for a +key+, raising a +KeyError+ if
    # a value could not be generated. Catches :result, and :abort thows
    # from rule processing.
    #
    # :call-seq:
    #   generate_value(key) => value || KeyError
    def generate_value(key)
      catch :result do
        catch :abort do
          rules = default_rules(key)
          rules.each do |rule|
            process_rule(rule.transform_keys(&:to_sym))
          end
        end
        raise KeyError, %(no rule succeeded for "#{key}")
      end
    end

    # Return the default value generation rules for a +key+.
    #
    # :call-seq:
    #   default_rules(key) => Array of Hash || KeyError
    def default_rules(key)
      @dictionary.fetch(@rule_prefix + key)
    end

    # Process a default value +rule+.
    #
    # :call-seq:
    #   process_rule(rule)
    #
    # Throws +:result+ or raises +KeyError+
    def process_rule(rule)
      method = "generate_value_for_#{rule.keys.first}".to_sym.to_proc

      method.call(self, **rule)
    rescue KeyError
      nil
    end

    # Match the value of a key agains regexps, returning the named
    # captured data.
    #
    # :call-seq:
    #   match_regexps(key, regexps) => Hash
    def match_regexps(key, regexps)
      string = @dictionary[key]

      enumerable(regexps).each_with_object({}) do |regexp, matches|
        matchdata = Regexp.new(regexp).match(string)
        next if matchdata.nil?
        matches.merge!(matchdata.named_captures.transform_keys(&:to_sym))
      end
    end

    # Format a +string+ with values from a +dictionary+
    # :call-seq:
    #   format_string(string, dictionary)
    def format_string(string, dictionary)
      Kernel.format(string, Hash.new { |_, key| dictionary[key] })
    rescue KeyError
      nil
    end

    # Make an array of a value unless it is already enumerable
    # :call-seq:
    #   enumerable(value) => value || [value]
    def enumerable(value)
      value.respond_to?(:each) ? value : [value]
    end
  end
end
