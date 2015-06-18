require 'argo/parser'
require 'json'

RSpec.describe 'property reference' do
  subject {
    json = read_fixture('property_reference.json')
    Argo::Parser.new(JSON.parse(json)).root
  }

  describe 'first property' do
    subject { super().properties.fetch(0) }

    it { is_expected.to be_kind_of(Argo::Schema) }
  end

  describe 'second property' do
    subject { super().properties.fetch(1) }

    it { is_expected.to be_kind_of(Argo::ArrayProperty) }
  end
end
