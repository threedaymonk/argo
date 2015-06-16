require 'argo/parser'
require 'json'

RSpec.describe 'Example schemata' do
  let(:schema) {
    File.read(File.expand_path("../../fixtures/#{schema_name}.json", __FILE__))
  }

  let(:root) {
    Argo::Parser.new(JSON.parse(schema)).root
  }

  subject { root }

  describe 'simplest schema' do
    let(:schema_name) { 'simplest' }

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
    let(:schema_name) { 'nested' }

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
    let(:schema_name) { 'basic_example' }

    it 'has a title' do
      expect(subject.title).
        to eq('Example Schema')
    end

    it 'is an object' do
      expect(subject.type).
        to eq(:object)
    end

    describe 'properties' do
      subject { root.properties }

      it 'has three items' do
        expect(subject.length).to eq(3)
      end

      describe 'first' do
        subject { root.properties.first }

        it 'has a name' do
          expect(subject.name).to eq('firstName')
        end

        it 'has no description' do
          expect(subject.description).to be_nil
        end

        it 'is required' do
          expect(subject).to be_required
        end
      end

      describe 'last' do
        subject { root.properties.last }

        it 'has a name' do
          expect(subject.name).to eq('age')
        end

        it 'has a description' do
          expect(subject.description).to eq('Age in years')
        end

        it 'is not required' do
          expect(subject).not_to be_required
        end

        it 'has constraints' do
          expect(subject.constraints).to eq({ minimum: 0 })
        end
      end
    end
  end
end
