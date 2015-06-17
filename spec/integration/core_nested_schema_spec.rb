require 'argo/parser'
require 'json'

RSpec.describe 'Core spec section 3.4 nested schema' do
  # See http://json-schema.org/latest/json-schema-core.html

  let(:root) {
    path = read_fixture('core_nested_schema.json')
    Argo::Parser.new(JSON.parse(path)).root
  }
  subject { root }

  it 'has a title' do
    expect(subject.title).to eq('root')
  end

  it 'knows its route' do
    expect(subject.route).to eq([])
  end

  describe 'nested schema' do
    subject { root.schemas['otherSchema'] }

    it 'has a title' do
      expect(subject.title).to eq('nested')
    end

    it 'knows its route' do
      expect(subject.route).to eq(%w[ otherSchema ])
    end
  end

  describe 'doubly nested schema' do
    subject { root.schemas['otherSchema'].schemas['anotherSchema'] }

    it 'has a title' do
      expect(subject.title).to eq('alsoNested')
    end

    it 'knows its route' do
      expect(subject.route).to eq(%w[ otherSchema anotherSchema ])
    end
  end

  it 'is an object' do
    expect(subject.type).
      to eq(:object)
  end
end
