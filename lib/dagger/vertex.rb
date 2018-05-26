require 'key_tree'
require_relative 'default'

module Dagger
  # Vertex class for Dagger, representing a filesystem directory
  class Vertex
    def initialize(name)
      @keys = initialize_forest(Default.proc(self))

      meta['_meta.name'] = name
      meta['_meta.basename'] = File.basename(name)
      meta['_meta.dirname'] = File.dirname(name)
    end

    attr_reader :inherited, :keys, :local, :meta

    def name
      meta['_meta.name']
    end

    def [](key)
      key = KeyTree::Path[key] unless key.is_a? KeyTree::Path
      return inherited[key[1..-1]] if key.prefix?(KeyTree::Path['^'])
      keys[key]
    end

    def fetch(key)
      keys.fetch(key)
    end

    def <<(keytree)
      local << keytree
    end

    def edge_added(edge)
      return unless edge.head?(self)
      inherited << edge.tail.keys
    end

    def edge_removed(edge)
      return unless edge.head?(self)
      inherited.reject! { |tree| tree.equal?(edge.tail.keys) }
    end

    alias to_s name

    private

    def initialize_forest(default_proc)
      forest = KeyTree::Forest.new
      forest << @meta ||= KeyTree::Tree.new
      forest << @local ||= KeyTree::Forest.new
      forest << default = KeyTree::Forest.new
      forest << @inherited ||= KeyTree::Forest.new
      default << KeyTree::Tree.new(&default_proc)
      forest
    end
  end
end
