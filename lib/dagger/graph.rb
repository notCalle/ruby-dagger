# frozen_string_literal: true

require 'tangle'
require 'tangle/mixin/directory'
require_relative 'vertex'

module Dagger
  # Specialization of Tangle::DAG
  class Graph < Tangle::DAG
    def self.load(dir, **kwargs)
      dir_options = {
        root: File.realpath(dir),
        loaders: %i[symlink_loader directory_loader keytree_loader]
      }
      new(directory: dir_options, currify: true, **kwargs)
    end

    def initialize(mixins: [], cached: false, **kwargs)
      @cached = cached
      @deferred_edges = []

      super(mixins: [Tangle::Mixin::Directory] + mixins, **kwargs)
      initialize_deferred
    end

    def select(&_filter)
      vertices.select { |vertex| yield(self, vertex) }
    end

    def cached?
      !(!@cached)
    end

    protected

    def symlink_loader(path:, parent:, lstat:, **)
      return unless lstat.symlink?

      target = local_path(File.realpath(path))
      parent = local_path(parent)
      defer_edge(target, parent, name: File.basename(path))
    end

    def directory_loader(path:, parent:, lstat:, **)
      return unless lstat.directory?

      path = local_path(path)
      vertex = Vertex.new(path, cached: cached?)
      add_vertex(vertex)
      return true if parent.nil?

      parent = local_path(parent)
      defer_edge(parent, path)
    end

    def keytree_loader(path:, parent:, lstat:, **)
      return unless lstat.file?

      fetch(local_path(parent)) << KeyTree.open(path)
    end

    private

    def initialize_deferred
      @deferred_edges.each do |args|
        *args, kwargs = args
        add_edge(*args.map { |name| fetch(name) }, **kwargs)
      end
    end

    def local_path(path)
      raise "#{path} outside root" unless path.start_with?(root_directory)

      result = path.delete_prefix(root_directory)
      return '/' if result.empty?

      result
    end

    def defer_edge(*args, **kwargs)
      @deferred_edges << [*args, kwargs]
    end
  end
end
