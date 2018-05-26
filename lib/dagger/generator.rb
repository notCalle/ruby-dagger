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

    delegate %i[dictionary] => :@context

    # Stop processing the current rule chain
    #
    # :call-seq:
    #   stop
    #
    # Raises +StopIteration+
    def stop
      raise StopIteration
    end

    # Update context attributes with new values
    #
    # :call-seq:
    #   update(key: value, ...)
    def update(**kwargs)
      kwargs.each { |key, value| @context[key] = value }
    end

    # Make an array of a value unless it is already enumerable
    #
    # :call-seq:
    #   enumerable(value) => value || [value]
    def enumerable(value)
      value.respond_to?(:each) ? value : [value]
    end
  end
end

Dir[__dir__ + '/generator/*.rb'].each { |file| load(file) }
