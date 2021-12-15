# frozen_string_literal: true

module Dagger
  # Context keeper for default value generation
  class Context
    attr_accessor :dictionary, :result, :stop, :vertex

    def initialize(dictionary:, result:, vertex:)
      @dictionary = dictionary
      @result = result
      @vertex = vertex
    end
  end
end
