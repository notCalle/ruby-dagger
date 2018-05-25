RSpec.describe Dagger::Default do
  before :context do
    @graph = Dagger.load(fixture('inheritence'))
  end

  it 'provides default values for missing keys' do
    expect(@graph['/child1']['class']).to eq 'child1'
  end

  it 'can shadow inherited values' do
    expect(@graph['/child1']['class']).not_to eq 'root'
  end
end
