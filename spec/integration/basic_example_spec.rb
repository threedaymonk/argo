require 'argo/parser'
require 'json'

RSpec.describe 'Example schemata' do
  # See http://json-schema.org/examples.html

  subject {
    path = read_fixture('basic_example.json')
    Argo::Parser.new(JSON.parse(path)).root
  }

  it 'has a title' do
    expect(subject.title).
      to eq('Example Schema')
  end

  it 'is an object' do
    expect(subject.type).
      to eq(:object)
  end

  describe 'properties' do
    subject { super().properties }

    it 'has three items' do
      expect(subject.length).to eq(3)
    end

    describe 'first (firstName)' do
      subject { super().first }

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

    describe 'last (age)' do
      subject { super().last }

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
        expect(subject.constraints).to eq(minimum: 0)
      end
    end
  end
end
