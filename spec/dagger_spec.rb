# frozen_string_literal: true

RSpec.describe Dagger do
  it 'is a module' do
    expect(Dagger).to be_a Module
  end

  it 'can load a graph from a directory structure' do
    expect {
      Dagger.load(fixture('graph'))
    }.not_to raise_error
  end

  context 'when loading a graph' do
    before :context do
      @graph = Dagger.load(fixture('graph'))
      @expected = {
        '/' => {},
        '/vertex1' => { 'a.b' => 2, 'c' => 3 },
        '/vertex2' => { 'b' => 2 }
      }
    end

    it 'has the expected vertices' do
      @expected.each_key do |name|
        expect { @graph.fetch(name) }.not_to raise_error
      end
    end

    it 'has the expected vertex key/values' do
      @expected.each do |name, keys|
        keys.each do |key, value|
          expect(@graph[name][key]).to eq value
        end
      end
    end
  end
end
