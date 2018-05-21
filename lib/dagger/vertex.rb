require 'key_tree'

module Dagger
  # Vertex class for Dagger, representing a filesystem directory
  class Vertex
    def initialize(name, &default_proc)
      @keys = KeyTree::Forest.new
      @keys << @local = KeyTree::Forest.new
      @keys << @meta = KeyTree::Tree.new
      @keys << @inherited = KeyTree::Forest.new
      @meta['_meta.name'] = name
      return unless block_given?
      @inherited << KeyTree::Tree.new(&default_proc)
    end

    attr_reader :inherited, :keys, :local, :meta

    def name
      @meta['_meta.name']
    end

    def [](key)
      keys[key]
    end

    def fetch(key)
      keys.fetch(key)
    end

    def <<(keytree)
      @local << keytree
    end

    def edge_added(edge)
      return unless edge.head?(self)
      @inherited << edge.tail.keys
    end

    def edge_removed(edge)
      return unless edge.head?(self)
      @inherited.reject! { |tree| tree.equal?(edge.tail.keys) }
    end

    alias to_s name
  end
end
