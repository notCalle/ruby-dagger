# frozen_string_literal: true

RSpec.describe Dagger::Generate::Integer do
  before :context do
    @graph = Dagger.load(fixture('numeric'))
  end

  it 'provides default float values using format strings' do
    expect(@graph['/float']['value']).to eq 1.4
  end

  it 'can calculate the sum of a list of values' do
    expect(@graph['/float']['sum']).to eq 15.5
  end

  it 'can calculate the product of a list of values' do
    expect(@graph['/float']['product']).to eq 0.79
  end

  it 'can calculate the arithmetic mean of a list of values' do
    expect(@graph['/float']['mean.arithmetic']).to eq 3.0
  end

  it 'can calculate the geometric mean of a list of values' do
    expect(@graph['/float']['mean.geometric']).to be_within(0.0005).of(0.924)
  end

  it 'can calculate the harmonic mean of a list of values' do
    expect(@graph['/float']['mean.harmonic']).to be_within(0.0005).of(0.270)
  end
end
