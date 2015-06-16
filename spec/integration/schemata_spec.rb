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
  end
end
