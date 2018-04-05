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

      def initialize_kwarg_directory(dir)
        @keys = KeyTree::Forest.new
        Dir.each_child(dir) do |file|
          path = File.join(dir, file)
          next unless File.file?(path)
          @keys << KeyTree.open(path)
        end
      end
    end
  end
end
