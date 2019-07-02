# frozen_string_literal: true

RSpec.describe Dagger::Vertex do
  before :context do
    @graph = Dagger.load(fixture('graph'))
    @parent = @graph['/vertex1']
    @vertex = @graph['/vertex2']
  end

  it 'can fetch the value for a key' do
    expect(@vertex['b']).to eq 2
  end

  it 'can fetch the parent value for a key' do
    expect(@vertex['^.b']).to eq @parent['b']
  end
end
