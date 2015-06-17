require 'argo/parser'
require 'json'

RSpec.describe 'entry-schema' do
  # See http://json-schema.org/example2.html

  let(:root) {
    path = read_fixture('entry-schema.json')
    Argo::Parser.new(JSON.parse(path)).root
  }
  subject { root }

  it 'has a description' do
    expect(subject.description).
      to eq('schema for an fstab entry')
  end
end
