# frozen_string_literal: true

RSpec.describe Dagger::Graph do
  it 'is a specialization of Tangle::DAG' do
    expect(Dagger::Graph.new).to be_a Tangle::DAG
  end

  it 'can load a graph from a directory' do
    expect { @graph = Dagger.load(fixture('graph')) }.not_to raise_error
    expect(@graph.vertices.count).to eq 3
  end

  it 'can load a graph from a directory with a config file' do
    expect { @graph = Dagger.load(fixture('options')) }.not_to raise_error
    expect(@graph.vertices.count).to eq 1
  end

  context 'when loading a graph with a config file' do
    it 'cannot escape the original root directory' do
      expect {
        @graph = Dagger.load(fixture('escape'))
      }.to raise_error RuntimeError, '../graph is outside root'
      expect(@graph).to be_nil
    end
  end
end
