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
    def initialize(dictionary,
                   cached: false,
                   fallback: nil,
                   rule_prefix: '_default')
      @dictionary = dictionary
      @cached = cached
      @fallback = fallback
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
    #
    # :call-seq:
    #   generate(tree, key) => value || KeyError
    #
    # Raises a +KeyError+ if the default value cannot be generated.
    # Raises a +RuntimeError+ in case of a deadlock for +key+.
    def generate(tree, key)
      key = KeyTree::Path[key] unless key.is_a? KeyTree::Path

      with_locked_key(key) { |locked_key| cached_value(tree, locked_key) }
    end

    private

    # Process a +block+ with mutex for +key+
    #
    # :call-seq:
    #   with_locked_key(key &->(locked_key)) => result
    def with_locked_key(key)
      raise %(deadlock detected: "#{key}") unless @locks.add?(key)
      yield(key)
    ensure
      @locks.delete(key)
    end

    # Return the default value for +key+, caching it in +tree+ if enabled.
    #
    # :call-seq:
    #   cached_value(tree, key) => value || KeyError
    def cached_value(tree, key)
      result = process(key)
    rescue KeyError
      raise if @fallback.nil?
      result = @fallback[key]
      raise if result.nil?
    ensure
      tree[key] = result if cached? && !result.nil?
    end

    # Process value generation rules for +context+, raising a +KeyError+
    # if a value could not be generated. Catches :result thows from rule
    # processing.
    #
    # :call-seq:
    #   yield => value || KeyError
    def process(key)
      catch do |ball|
        default_rules(key).each do |rule|
          context = Context.new(result: ball, dictionary: @dictionary)

          process_rule_chain(rule, context)
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

    # Process the methods in a rule chain
    #
    # :call-seq:
    #   process_rule_chain(rule_chain, context)
    def process_rule_chain(rule_chain, context)
      rule_chain.each do |key, arg|
        klass = Dagger::Generate.const_get(camelize(key))
        klass[context, arg, &->(value) { throw context.result, value }]
      end
    rescue StopIteration
      nil
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
