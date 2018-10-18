# frozen_string_literal: true

require 'json'
require 'yaml'
require 'dagger/graph'

# Manage a DAG, stored in a posix file structure
#
# The file `.dagger.yaml`, if present in the root directory,
# will be loaded as options for Tangle::Mixin::Directory, when
# loading the graph.
#
module Dagger
  def self.load(dir, **kwargs)
    Graph.load(dir, **kwargs)
  end
end

KeyTree::Loader.fallback(KeyTree::Loader::Nil)
