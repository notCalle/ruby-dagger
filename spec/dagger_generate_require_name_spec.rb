RSpec.describe Dagger::Generate::RequireName do
  before :context do
    @graph = Dagger.load(fixture('project'))
  end

  it 'allows default value processing for matches' do
    expect(@graph['/status/done']['status']).to eq 'done'
  end

  it 'denies default value processing for misses' do
    expect(@graph['/feature/default-values']['status']).to eq 'done'
  end
end
