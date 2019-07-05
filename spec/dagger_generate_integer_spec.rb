# frozen_string_literal: true

RSpec.describe Dagger::Generate::Integer do
  before :context do
    @graph = Dagger.load(fixture('numeric'))
  end

  it 'provides default integer values using format strings' do
    expect(@graph['/integer']['value']).to eq 1
  end

  it 'can calculate the sum of a list of values' do
    expect(@graph['/integer']['sum']).to eq 14
  end

  it 'can calculate the product of a list of values' do
    expect(@graph['/integer']['product']).to eq 0
  end
end
