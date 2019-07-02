# frozen_string_literal: true

RSpec.describe Dagger::Generate::Integer do
  before :context do
    @graph = Dagger.load(fixture('numeric'))
  end

  it 'provides default integer values using format strings' do
    expect(@graph['/integer']['value']).to eq 1
  end
end
