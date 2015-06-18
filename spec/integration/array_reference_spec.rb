require 'argo/parser'
require 'json'

RSpec.describe 'array reference' do
  subject {
    json = read_fixture('array_reference.json')
    Argo::Parser.new(JSON.parse(json)).root
  }

  describe 'property with reference' do
    subject { super().properties.fetch('a') }

    it { is_expected.to be_kind_of(Argo::ArrayProperty) }

    describe 'items' do
      subject { super().items }

      it 'has one property' do
        expect(subject.properties.keys).to eq(%w[ thing_id ])
      end
    end
  end

  describe 'property with array containing one reference' do
    subject { super().properties.fetch('b') }

    it { is_expected.to be_kind_of(Argo::ArrayProperty) }

    describe 'items' do
      subject { super().items }

      it 'has one property' do
        expect(subject.properties.keys).to eq(%w[ thing_id ])
      end
    end
  end
end
