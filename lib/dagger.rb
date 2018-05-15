require 'dagger/graph'

# Manage a DAG, stored in a posix file structure
#
module Dagger
  def self.load(dir)
    Graph.load(dir)
  end
end
