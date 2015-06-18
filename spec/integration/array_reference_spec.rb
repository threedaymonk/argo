require 'argo/parser'
require 'json'

RSpec.describe 'array reference' do
  subject {
    json = read_fixture('array_reference.json')
    Argo::Parser.new(JSON.parse(json)).root
  }

  describe 'first property' do
    subject { super().properties.first }

    it { is_expected.to be_kind_of(Argo::ArrayProperty) }
  end
end
