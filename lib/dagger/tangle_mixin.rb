require 'key_tree'

module Dagger
  module TangleMixin
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
