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
    expect(subject.title).
      to eq('root')
  end

  it 'has a nested schema with a title' do
    expect(subject.schemas['otherSchema'].title).
      to eq('nested')
  end

  it 'has a nested schema with a nested schema with a title' do
    expect(subject.schemas['otherSchema'].schemas['anotherSchema'].title).
      to eq('alsoNested')
  end

  it 'is an object' do
    expect(subject.type).
      to eq(:object)
  end
end
