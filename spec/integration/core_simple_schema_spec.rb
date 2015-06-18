require 'argo/parser'
require 'json'

RSpec.describe 'Core spec section 3.4 simple schema' do
  # See http://json-schema.org/latest/json-schema-core.html

  subject {
    path = read_fixture('core_simple_schema.json')
    Argo::Parser.new(JSON.parse(path)).root
  }

  it 'has a title' do
    expect(subject.title).to eq('root')
  end

  it 'is an object' do
    expect(subject.type).to eq(:object)
  end
end
