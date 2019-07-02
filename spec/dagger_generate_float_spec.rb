# frozen_string_literal: true

RSpec.describe Dagger::Generate::Integer do
  before :context do
    @graph = Dagger.load(fixture('numeric'))
  end

  it 'provides default float values using format strings' do
    expect(@graph['/float']['value']).to eq 1.4
  end
end
