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

  describe 'properties' do
    subject { root.properties }

    it 'has four items' do
      expect(subject.length).to eq(4)
    end

    describe 'first' do
      subject { root.properties[0] }

      it { is_expected.to be_kind_of(Argo::ObjectProperty) }

      it 'has a name' do
        expect(subject.name).to eq('storage')
      end

      it 'is required' do
        expect(subject).to be_required
      end
    end

    describe 'second' do
      subject { root.properties[1] }

      it { is_expected.to be_kind_of(Argo::StringProperty) }

      it 'has a name' do
        expect(subject.name).to eq('fstype')
      end

      it 'is not required' do
        expect(subject).not_to be_required
      end

      it 'has constraints' do
        expect(subject.constraints).to eq(enum: %w[ ext3 ext4 btrfs ])
      end
    end

    describe 'third' do
      subject { root.properties[2] }

      it { is_expected.to be_kind_of(Argo::ArrayProperty) }

      it 'has a name' do
        expect(subject.name).to eq('options')
      end

      describe 'items' do
        subject { root.properties[2].items }

        it { is_expected.to be_kind_of(Argo::StringProperty) }
      end

      it 'is not required' do
        expect(subject).not_to be_required
      end

      it 'has constraints' do
        expect(subject.constraints).to eq(
          min_items: 1,
          unique_items: true
        )
      end
    end

    describe 'fourth' do
      subject { root.properties[3] }

      it { is_expected.to be_kind_of(Argo::BooleanProperty) }

      it 'has a name' do
        expect(subject.name).to eq('readonly')
      end

      it 'is not required' do
        expect(subject).not_to be_required
      end
    end
  end
end
