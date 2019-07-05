# frozen_string_literal: true

require 'forwardable'

module Dagger
  # Abstract super class for default value generators.
  # Stores the +Context+ on initialization, and provides private
  # helper methods to concrete subclasses.
  #
  # +Context+ key access:
  # :call-seq:
  #   dictionary => Hash-like with current key lookup dictionary.
  #
  # +Context+ value update:
  # :call-seq:
  #   update(key: value, ...)
  #
  # Stop the processing of current rule chain:
  # :call-seq:
  #   stop
  #
  # Wrap non-enumerable objects in an +Array+
  # :call-seq:
  #   enumerable(value) => value || [value]
  #
  # Concrete subclasses must implement:
  # :call-seq:
  #   process(arg, &->(value))
  #
  # [+arg+]     Value for current method in the +rule_chain+
  # [+value+]   If a value was found it should be +yield+:ed
  class Generator
    extend Forwardable

    def self.[](context, arg, &result_yielder)
      new(context).process(arg, &result_yielder)
    end

    def initialize(context)
      @context = context
    end

    private

    delegate %i[dictionary vertex] => :@context

    # Stop processing the current rule chain
    #
    # :call-seq:
    #   stop
    def stop
      throw @context.stop
    end

    # Update context attributes with new values
    #
    # :call-seq:
    #   update(key: value, ...)
    def update(**kwargs)
      kwargs.each { |key, value| @context[key] = value }
    end

    # Make an array of a value unless it is already an array
    #
    # :call-seq:
    #   array(value) => value || [value]
    def array(value)
      value.respond_to?(:to_ary) ? value : [value]
    end

    # Format a +string+ with values from a +dictionary+
    #
    # :call-seq:
    #   format(string)
    def format_string(string)
      hash = Hash.new do |_, key|
        result = @context.dictionary[key]
        next result unless result.nil?

        return nil
      end

      format(string, hash)
    end
  end
end

Dir[__dir__ + '/generate/*.rb'].each { |file| load(file) }
