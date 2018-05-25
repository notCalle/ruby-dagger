require 'forwardable'

module Dagger
  class Generator
    extend Forwardable

    def initialize(context)
      @context = context
    end

    delegate %i[dictionary result rule_chain] => :@context

    private

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
