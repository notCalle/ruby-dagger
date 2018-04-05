RSpec.describe Dagger::Graph do
  before :context do
    @graph = Dagger::Graph.new
  end

  it 'is a specialization of Tangle::DAG' do
    expect(@graph).to be_a Tangle::DAG
  end

  it 'can add a vertex from a directory of files' do
    expect {
      @graph.add_vertex(name: 'vertex1', directory: fixture('graph/vertex1'))
    }.not_to raise_error
  end

  context 'when adding a vertex' do
    before :context do
      @graph = Dagger::Graph.new
      @vertex = @graph.add_vertex(name: 'vertex1',
                                  directory: fixture('graph/vertex1'))
      @expected_values = { 'a.b' => 1, 'c' => 2 }
    end

    it 'can have keys' do
      expect(@vertex).to respond_to :keys
    end

    it 'can fetch values for keys' do
      @expected_values.each do |key, value|
        expect(@vertex.keys[key]).to eq value
      end
    end
  end
end
