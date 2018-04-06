require 'tangle'
require 'dagger/tangle_mixin'

module Dagger
  class Graph < Tangle::DAG
    DEFAULT_MIXINS = [Tangle::Mixin::Ancestry, Dagger::TangleMixin].freeze
  end
end
