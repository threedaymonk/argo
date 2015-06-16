require 'argo/parser'
require 'json'

RSpec.describe 'Example schemata' do
  let(:root) {
    path = File.read(File.expand_path("../../fixtures/#{schema_name}.json", __FILE__))
    Argo::Parser.new(JSON.parse(path)).root
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

        it { is_expected.to be_kind_of(Argo::StringProperty) }

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

        it { is_expected.to be_kind_of(Argo::IntegerProperty) }

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

  describe 'simple example' do
    let(:schema_name) { 'simple_example' }

    it 'has a title' do
      expect(subject.title).to eq('Product')
    end

    it 'is an object' do
      expect(subject.type).to eq(:object)
    end

    it 'refers to the draft specification v4' do
      expect(subject.spec).to eq('http://json-schema.org/draft-04/schema#')
    end

    it 'has a description' do
      expect(subject.description).to eq("A product from Acme's catalog")
    end

    describe 'properties' do
      subject { root.properties }

      it 'has four items' do
        expect(subject.length).to eq(4)
      end

      describe 'first' do
        subject { root.properties[0] }

        it { is_expected.to be_kind_of(Argo::IntegerProperty) }

        it 'has a name' do
          expect(subject.name).to eq('id')
        end

        it 'has a description' do
          expect(subject.description).
            to eq('The unique identifier for a product')
        end

        it 'is required' do
          expect(subject).to be_required
        end

        it 'has no constraints' do
          expect(subject.constraints).to be_empty
        end
      end

      describe 'second' do
        subject { root.properties[1] }

        it { is_expected.to be_kind_of(Argo::StringProperty) }

        it 'has a name' do
          expect(subject.name).to eq('name')
        end

        it 'has a description' do
          expect(subject.description).to eq('Name of the product')
        end

        it 'is required' do
          expect(subject).to be_required
        end

        it 'has no constraints' do
          expect(subject.constraints).to be_empty
        end
      end

      describe 'third' do
        subject { root.properties[2] }

        it { is_expected.to be_kind_of(Argo::NumberProperty) }

        it 'has a name' do
          expect(subject.name).to eq('price')
        end

        it 'has no description' do
          expect(subject.description).to be_nil
        end

        it 'is required' do
          expect(subject).to be_required
        end

        it 'has constraints' do
          expect(subject.constraints).
            to eq({ minimum: 0, exclusiveMinimum: true })
        end
      end

      describe 'fourth' do
        subject { root.properties[3] }

        it { is_expected.to be_kind_of(Argo::ArrayProperty) }

        it 'has a name' do
          expect(subject.name).to eq('tags')
        end

        it 'has no description' do
          expect(subject.description).to be_nil
        end

        it 'is not required' do
          expect(subject).not_to be_required
        end

        it 'has constraints' do
          expect(subject.constraints).
            to eq({ minItems: 1, uniqueItems: true })
        end

        describe 'items' do
          subject { root.properties[3].items }

          it { is_expected.to be_kind_of(Argo::StringProperty) }
        end
      end
    end
  end
end
