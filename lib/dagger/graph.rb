require 'tangle'
require 'tangle/mixin/directory'
require_relative 'vertex'

module Dagger
  # Specialization of Tangle::DAG
  class Graph < Tangle::DAG
    DEFAULT_MIXINS = [Tangle::Mixin::Directory].freeze

    def self.load(dir)
      dir_options = {
        root: File.realpath(dir),
        loaders: %i[symlink_loader directory_loader keytree_loader]
      }
      new(directory: dir_options)
    end

    def initialize(*)
      @deferred_edges = []
      super
      @deferred_edges.each do |args|
        tail, head, *kwargs = args
        add_edge(*[tail, head].map { |name| fetch(name) }, *kwargs)
      end
    end

    def select(&_filter)
      vertices.select { |vertex| yield(self, vertex) }
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
      vertex = Vertex.new(path)
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

    def local_path(path)
      raise "#{path} outside root" unless path.start_with?(root_directory)

      result = path.delete_prefix(root_directory)
      return '/' if result.empty?
      result
    end

    def defer_edge(*args)
      @deferred_edges << args
    end
  end
end
