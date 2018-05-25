require 'set'
require_relative 'context'
require_relative 'generator'

module Dagger
  # Default value generator for a dictionary
  class Default
    # Initialize a default value generator for a +dictionary+
    #
    # :call-seq:
    #   new(dictionary) => Dagger::Default
    #   new(*, cached: false)
    #   new(*, rule_prefix: '_default')
    def initialize(dictionary, cached: false, rule_prefix: '_default')
      @dictionary = dictionary
      @cached = cached
      @rule_prefix = KeyTree::Path[rule_prefix]
      @default_proc = ->(tree, key) { generate(tree, key) }
      @locks = Set[]
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
      key = KeyTree::Path[key] unless key.is_a? KeyTree::Path
      raise %(deadlock detected: "#{key}") unless @locks.add?(key)

      return result = process(key) unless cached?
      tree[key] = result unless result.nil?
    ensure
      @locks.delete(key)
    end

    private

    # Process value generation rules for +context+, raising a +KeyError+
    # if a value could not be generated. Catches :result thows from rule
    # processing.
    #
    # :call-seq:
    #   yield => value || KeyError
    def process(key)
      catch do |ball|
        default_rules(key).each do |rule|
          context = Context.new(result: ball,
                                dictionary: @dictionary,
                                rule_chain: rule.clone)

          process_rule(context) until context.rule_chain.empty?
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

    # Call the processing method for the first clause of a rule
    #
    # :call-seq:
    #   call_rule
    def process_rule(context)
      key, arg = *context.rule_chain.first
      context.rule_chain.delete(key)
      klass = Dagger::Generate.const_get(camelize(key))
      klass[context, arg, &->(value) { throw context.result, value }]
    end

    # Convert snake_case to CamelCase
    #
    # :call-seq:
    #   camelize(string)
    def camelize(string)
      string.split('_').map!(&:capitalize).join
    end
  end
end
