require 'key_tree'
require_relative 'default'

module Dagger
  # Vertex class for Dagger, representing a filesystem directory
  class Vertex
    def initialize(name, cached: false)
      @keys = initialize_forest(cached)

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

    def flatten(cleanup: false)
      forest = initialize_forest(true)

      forest.flatten.each_key do |key|
        forest[key[1..-1]] if key.prefix?(KeyTree::Path['_default'])
      end

      return flattened = forest.flatten unless cleanup
      flattened.delete_if { |key, _| key.to_s =~ /^_/ }
    end

    def flatten!
      flattened = flatten
      @keys.clear << flattened
    end

    def to_h
      flatten(cleanup: true).to_h
    end

    def to_yaml
      flatten(cleanup: true).to_yaml
    end

    def to_json
      flatten(cleanup: true).to_json
    end

    alias to_s name

    private

    def initialize_forest(cached)
      forest = KeyTree::Forest.new
      forest << @meta ||= KeyTree::Tree.new
      forest << @local ||= KeyTree::Forest.new
      forest << default = KeyTree::Forest.new
      forest << @inherited ||= KeyTree::Forest.new
      default << initialize_default_tree(cached)
      forest
    end

    def initialize_default_tree(cached)
      default_args = cached ? { cached: true, fallback: @inherited } : {}
      default_proc = Default.proc(self, default_args)
      KeyTree::Tree.new(&default_proc)
    end
  end
end
