require 'argo/parser'
require 'json'

RSpec.describe 'Core spec section 3.4 nested schema' do
  # See http://json-schema.org/latest/json-schema-core.html

  subject {
    json = read_fixture('core_nested_schema.json')
    Argo::Parser.new(JSON.parse(json)).root
  }

  it 'has the title "root"' do
    expect(subject.title).to eq('root')
  end

  it 'has an empty route' do
    expect(subject.route).to eq([])
  end

  describe 'nested schema' do
    subject { super().schemas.fetch('otherSchema') }

    it 'has the title "nested"' do
      expect(subject.title).to eq('nested')
    end

    it 'has a one-element route' do
      expect(subject.route).to eq(%w[ otherSchema ])
    end

    describe 'doubly nested schema' do
      subject { super().schemas.fetch('anotherSchema') }

      it 'has the title "alsoNested"' do
        expect(subject.title).to eq('alsoNested')
      end

      it 'has a two-element route' do
        expect(subject.route).to eq(%w[ otherSchema anotherSchema ])
      end
    end
  end

  it 'is an object' do
    expect(subject.type).
      to eq(:object)
  end
end
