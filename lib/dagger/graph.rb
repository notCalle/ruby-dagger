require 'dagger/vertex'
require 'tangle'
require 'tangle/mixin/directory'

module Dagger
  # Specialization of Tangle::DAG
  class Graph < Tangle::DAG
    DEFAULT_MIXINS = [Tangle::Mixin::Directory].freeze

    def self.load(dir)
      new(directory: {
            root: File.realpath(dir),
            loaders: %i[symlink_loader directory_loader keytree_loader]
          })
    end

    def initialize(*_args)
      @deferred_edges = []
      super
      @deferred_edges.each do |args|
        add_edge(*args.map { |name| fetch(name) }, callback: :did_add_edge)
      end
    end

    def add_edge(*vertices, callback: nil, **kwargs)
      edge = super(*vertices, **kwargs)
      unless callback.nil?
        vertices.each do |vertex|
          callback.to_proc.call(vertex, edge)
        end
      end
      edge
    end

    def select(filter)
      vertices.select { |vertex| send(filter, vertex) }
    end

    protected

    def symlink_loader(path, parent)
      return unless File.symlink?(path)

      target = local_path(File.realpath(path))
      parent = local_path(parent)
      defer_edge(target, parent)
    end

    def directory_loader(path, parent)
      return unless File.directory?(path)

      path = local_path(path)
      vertex = Vertex.new(path)
      add_vertex(vertex, name: path)
      return true if parent.nil?
      parent = local_path(parent)
      defer_edge(parent, path)
    end

    def keytree_loader(path, parent)
      return unless File.file?(path)

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
