require 'argo/parser'
require 'json'

RSpec.describe 'property reference' do
  subject {
    json = read_fixture('property_reference.json')
    Argo::Parser.new(JSON.parse(json)).root
  }

  describe 'a' do
    subject { super().properties.fetch('a') }

    it { is_expected.to be_kind_of(Argo::Schema) }
  end

  describe 'b' do
    subject { super().properties.fetch('b') }

    it { is_expected.to be_kind_of(Argo::ArrayProperty) }
  end

  describe 'c' do
    subject { super().properties.fetch('c') }

    it { is_expected.to be_kind_of(Argo::ArrayProperty) }
  end
end
