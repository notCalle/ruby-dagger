RSpec.describe Dagger::Graph do
  it 'is a specialization of Tangle::DAG' do
    expect(Dagger::Graph.new).to be_a Tangle::DAG
  end
end
