# frozen_string_literal: true

require 'tangle'
require 'tangle/mixin/directory'
require_relative 'vertex'

module Dagger
  # Specialization of Tangle::DAG
  class Graph < Tangle::DAG
    class << self
      using KeyTree::Refine::DeepHash

      def load(dir = '.', **kwargs)
        kwargs[:directory] = {
          root: Pathname.new(dir),
          loaders: %i[symlink_loader directory_loader keytree_loader]
        }
        merge_configfile_options!(kwargs)
        new(currify: true, **kwargs)
      end

      private

      def merge_configfile_options!(options)
        dir_options = options.fetch(:directory)
        root = dir_options.fetch(:root)
        cfgfile = root / '.dagger.yaml'

        options.deep_merge! load_config(cfgfile) if cfgfile.file?
        new_root = root / dir_options.fetch(:root)
        raise "#{new_root} is outside root" unless path_inside?(new_root, root)

        dir_options[:root] = new_root.to_s
      end

      def load_config(cfgfile)
        YAML.load_file(cfgfile).deep_transform_keys!(&:to_sym)
      end
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

    def path_inside?(path, root)
      File.realpath(path, root).start_with? File.realpath(root)
    end

    def local_path(path)
      raise "#{path} is outside root" unless path_inside?(path, root_directory)

      result = path.delete_prefix(root_directory)
      return '/' if result.empty?

      result
    end

    def defer_edge(*args, **kwargs)
      @deferred_edges << [*args, kwargs]
    end
  end
end
