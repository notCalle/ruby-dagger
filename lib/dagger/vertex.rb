require 'key_tree'

module Dagger
  # Vertex class for Dagger, representing a filesystem directory
  class Vertex
    attr_reader :keys, :local, :inherited
    attr_reader :name

    def initialize(name, &default_proc)
      @name = name
      @keys = KeyTree::Forest.new
      @keys << @local = KeyTree::Forest.new
      @keys << @inherited = KeyTree::Forest.new
      return unless block_given?
      @inherited << KeyTree::Tree.new(&default_proc)
    end

    def [](key)
      keys[key]
    end

    def <<(keytree)
      @local << keytree
    end

    def edge_added(edge)
      return unless edge.head?(self)
      @inherited << edge.tail.keys
    end

    alias to_s name
  end
end
