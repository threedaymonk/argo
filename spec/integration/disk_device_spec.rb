require 'argo/parser'
require 'json'

RSpec.describe 'diskDevice' do
  # See http://json-schema.org/example2.html

  subject {
    json = read_fixture('diskDevice.json')
    Argo::Parser.new(JSON.parse(json)).root
  }

  it 'has no title' do
    expect(subject.title).to be_nil
  end

  describe 'properties' do
    subject { super().properties }

    it 'has two items' do
      expect(subject.length).to eq(2)
    end

    describe 'type' do
      subject { super().fetch('type') }

      it { is_expected.to be_kind_of(Argo::StringProperty) }

      it 'is required' do
        expect(subject).to be_required
      end

      it 'has an enum constraint' do
        expect(subject.constraints).to eq(enum: %w[ disk ])
      end
    end

    describe 'device' do
      subject { super().fetch('device') }

      it { is_expected.to be_kind_of(Argo::StringProperty) }

      it 'is required' do
        expect(subject).to be_required
      end

      it 'has a pattern constraint' do
        expect(subject.constraints).to eq(pattern: '^/dev/[^/]+(/[^/]+)*$')
      end
    end
  end
end
