RSpec.describe Dagger::Generate::Regexp do
  before :context do
    @graph = Dagger.load(fixture('project'))
  end

  it 'provides default values using regexp named captures' do
    expect(@graph['/milestone/release-1.0']['release']).to eq '1.0'
  end
end
