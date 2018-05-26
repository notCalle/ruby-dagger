RSpec.describe Dagger::Generate::String do
  before :context do
    @graph = Dagger.load(fixture('project'))
  end

  it 'provides default values using format strings' do
    expect(@graph['/status/todo']['status']).to eq 'todo'
  end
end
