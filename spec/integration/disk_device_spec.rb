require 'argo/parser'
require 'json'

RSpec.describe 'diskDevice' do
  # See http://json-schema.org/example2.html

  subject {
    path = read_fixture('diskDevice.json')
    Argo::Parser.new(JSON.parse(path)).root
  }

  it 'has no title' do
    expect(subject.title).to be_nil
  end

  describe 'properties' do
    subject { super().properties }

    it 'has two items' do
      expect(subject.length).to eq(2)
    end

    describe 'first' do
      subject { super().fetch(0) }

      it { is_expected.to be_kind_of(Argo::StringProperty) }

      it 'has a name' do
        expect(subject.name).to eq('type')
      end

      it 'is required' do
        expect(subject).to be_required
      end

      it 'has constraints' do
        expect(subject.constraints).to eq(enum: %w[ disk ])
      end
    end

    describe 'second' do
      subject { super().fetch(1) }

      it { is_expected.to be_kind_of(Argo::StringProperty) }

      it 'has a name' do
        expect(subject.name).to eq('device')
      end

      it 'is required' do
        expect(subject).to be_required
      end

      it 'has constraints' do
        expect(subject.constraints).to eq(pattern: '^/dev/[^/]+(/[^/]+)*$')
      end
    end
  end
end
