require 'argo/parser'
require 'json'

RSpec.describe 'diskUUID' do
  # See http://json-schema.org/example2.html

  subject {
    path = read_fixture('diskUUID.json')
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

    describe 'first (type)' do
      subject { super().fetch(0) }

      it { is_expected.to be_kind_of(Argo::StringProperty) }

      it 'has a name' do
        expect(subject.name).to eq('type')
      end

      it 'is required' do
        expect(subject).to be_required
      end

      it 'has an enum constraint' do
        expect(subject.constraints).to eq(enum: %w[ disk ])
      end
    end

    describe 'second (label)' do
      subject { super().fetch(1) }

      it { is_expected.to be_kind_of(Argo::StringProperty) }

      it 'has a name' do
        expect(subject.name).to eq('label')
      end

      it 'is required' do
        expect(subject).to be_required
      end

      it 'has a pattern constraint' do
        expect(subject.constraints).to eq(
          pattern: '^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$'
        )
      end
    end
  end
end
