require 'argo/parser'
require 'json'

RSpec.describe 'Example schemata' do
  subject {
    json = read_fixture('simple_example.json')
    Argo::Parser.new(JSON.parse(json)).root
  }

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
    subject { super().properties }

    it 'has four items' do
      expect(subject.length).to eq(4)
    end

    describe 'id' do
      subject { super().fetch('id') }

      it { is_expected.to be_kind_of(Argo::IntegerProperty) }

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

    describe 'name' do
      subject { super().fetch('name') }

      it { is_expected.to be_kind_of(Argo::StringProperty) }

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

    describe 'price' do
      subject { super().fetch('price') }

      it { is_expected.to be_kind_of(Argo::NumberProperty) }

      it 'has no description' do
        expect(subject.description).to be_nil
      end

      it 'is required' do
        expect(subject).to be_required
      end

      it 'has constraints' do
        expect(subject.constraints).
          to eq(minimum: 0, exclusive_minimum: true)
      end
    end

    describe 'tags' do
      subject { super().fetch('tags') }

      it { is_expected.to be_kind_of(Argo::ArrayProperty) }

      it 'has no description' do
        expect(subject.description).to be_nil
      end

      it 'is not required' do
        expect(subject).not_to be_required
      end

      it 'has constraints' do
        expect(subject.constraints).
          to eq(min_items: 1, unique_items: true)
      end

      describe 'items' do
        subject { super().items }

        it { is_expected.to be_kind_of(Argo::StringProperty) }
      end
    end
  end
end
