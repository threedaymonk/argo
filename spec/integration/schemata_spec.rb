require 'argo/parser'
require 'json'

RSpec.describe 'Example schemata' do
  subject {
    Argo::Parser.new(JSON.parse(schema)).root
  }

  describe 'simplest schema' do
    let(:schema) {
      <<-JSON
        {
          "title": "root"
        }
      JSON
    }

    it 'has a title' do
      expect(subject.title).
        to eq('root')
    end

    it 'is an object' do
      expect(subject.type).
        to eq(:object)
    end
  end

  describe 'nested schema' do
    let(:schema) {
      <<-JSON
        {
          "title": "root",
          "otherSchema": {
            "title": "nested",
            "anotherSchema": {
              "title": "alsoNested"
            }
          }
        }
      JSON
    }

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

  describe 'basic example' do
    let(:schema) {
      <<-JSON
        {
          "title": "Example Schema",
          "type": "object",
          "properties": {
            "firstName": {
              "type": "string"
            },
            "lastName": {
              "type": "string"
            },
            "age": {
              "description": "Age in years",
              "type": "integer",
              "minimum": 0
            }
          },
          "required": ["firstName", "lastName"]
        }
      JSON
    }

    it 'has a title' do
      expect(subject.title).
        to eq('Example Schema')
    end

    it 'is an object' do
      expect(subject.type).
        to eq(:object)
    end

  end
end
