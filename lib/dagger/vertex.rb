# frozen_string_literal: true

require 'key_tree'
require 'key_tree/refinements'
require_relative 'default'

module Dagger
  # Vertex class for Dagger, representing a filesystem directory
  #
  #   dir/
  #     file.yaml         => keytree
  #     prefix@file.yaml  => prefix.keytree
  #
  #   +forest+ = [ +meta+       = {},
  #                +local+        [ { file_keys }, ... ],
  #                               [ { Default } ],
  #                +inherited+  = [ [ parent ], ... ]
  #              ]
  #
  class Vertex
    using KeyTree::Refinements

    def initialize(name, cached: false)
      @forest = initialize_forest(cached)
      @meta['_meta.name'] = name
      @meta['_meta.basename'] = File.basename(name)
      @meta['_meta.dirname'] = File.dirname(name)
    end

    def to_key_forest
      @forest
    end
    alias to_key_wood to_key_forest

    def name
      @forest['_meta.name']
    end
    alias to_s name

    def [](key)
      key = key.to_key_path
      return @inherited[key.drop(1)] if key.prefix?('^')

      @forest[key]
    end

    def fetch(key, *default, &block)
      key = key.to_key_path
      return @inherited.fetch(key.drop(1), *default, &block) if key.prefix?('^')

      @forest.fetch(key, *default, &block)
    end

    def <<(keytree)
      @local << keytree
    end

    def edge_added(edge)
      return unless edge.head?(self)
      @inherited << edge.tail.to_key_wood
    end

    def edge_removed(edge)
      return unless edge.head?(self)
      @inherited.reject! { |tree| tree.equal?(edge.tail.to_key_wood) }
    end

    def added_to_graph(graph)
      raise %(belongs another graph) if @graph&.!= graph
      @graph = graph
    end

    def removed_from_graph(graph)
      raise %(not part of graph) if @graph&.!= graph
      @graph = nil
    end

    def flatten(cleanup: true)
      forest = initialize_forest(true)

      forest.key_paths.select { |key| key.prefix?('_default') }.each do |key|
        forest[key.drop(1)]
      end

      flattened = forest.flatten
      return flattened unless cleanup
      flattened.to_h.delete_if { |key| key.to_s.start_with?('_') }
      flattened
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
