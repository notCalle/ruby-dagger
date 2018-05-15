require 'key_tree'

module Dagger
  # Vertex class for Dagger, representing a filesystem directory
  class Vertex
    attr_reader :keys, :name

    def initialize(name)
      @name = name
      @keys = KeyTree::Forest.new
    end

    def [](key)
      keys[key]
    end

    def <<(keytree)
      keys << keytree
    end

    def did_add_edge(edge)
      return unless edge.head?(self)
      self << edge.tail.keys
    end
  end
end
