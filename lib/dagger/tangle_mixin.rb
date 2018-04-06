require 'key_tree'

module Dagger
  module TangleMixin
    # Tangle::Graph mixin for initializing a KeyTree::Forest from the contents
    # of a directory
    module Graph
      private

      def initialize_kwarg_directory(base_dir)
        @base_dir = File.realpath(base_dir)

        load_vertex(@base_dir + '/')

        Dir[File.join(@base_dir, '**/*')].each do |path|
          if File.symlink?(path)
            load_edge(path)
          elsif File.directory?(path)
            load_vertex(path)
          end
        end
      end

      def load_vertex(path)
        name = path.delete_prefix(@base_dir)
        add_vertex(name: name, directory: path)
      end

      def load_edge(path)
        name = path.delete_prefix(@base_dir)
        source = File.dirname(name)
        target = File.realpath(path)
        target_name = target.delete_prefix(@base_dir)
        parent = begin
          get_vertex(target_name)
        rescue KeyError
          load_vertex(target)
        end
        add_edge(get_vertex(source), parent, name: name)
      end
    end

    # Tangle::Vertex mixin for initializing a KeyTree::Forest from the contents
    # of a directory
    module Vertex
      def [](key)
        keys[key]
      end

      attr_reader :keys

      private

      # Initialize the vertex with a keytree (forest) from a directory
      # of files.
      def initialize_kwarg_directory(dir)
        @keys = KeyTree.open_all(dir)
      end
    end

    # Tangle::Vertex mixin for initializing a KeyTree::Forest from the contents
    # of a directory
    module Edge
      attr_reader :name

      private

      def initialize_kwarg_name(name)
        @name = name
      end
    end
  end
end
