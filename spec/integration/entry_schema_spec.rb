require 'argo/parser'
require 'json'

RSpec.describe 'entry-schema' do
  # See http://json-schema.org/example2.html

  subject {
    json = read_fixture('entry-schema.json')
    Argo::Parser.new(JSON.parse(json)).root
  }

  it 'has a description' do
    expect(subject.description).
      to eq('schema for an fstab entry')
  end

  describe 'properties' do
    subject { super().properties }

    it 'has four items' do
      expect(subject.length).to eq(4)
    end

    describe 'storage' do
      subject { super().fetch('storage') }

      it { is_expected.to be_kind_of(Argo::ObjectProperty) }

      it 'is required' do
        expect(subject).to be_required
      end

      describe 'one_of constraint' do
        subject { super().constraints.fetch(:one_of) }

        it 'has four entries' do
          expect(subject.length).to eq(4)
        end

        describe 'first' do
          subject { super().fetch(0) }

          it { is_expected.to be_kind_of(Argo::Schema) }

          describe 'properties' do
            subject { super().properties }

            it 'has two items' do
              expect(subject.length).to eq(2)
            end

            describe 'type' do
              subject { super().fetch('type') }

              it { is_expected.to be_kind_of(Argo::StringProperty) }
            end

            describe 'device' do
              subject { super().fetch('device') }

              it { is_expected.to be_kind_of(Argo::StringProperty) }
            end
          end
        end
      end
    end

    describe 'fstype' do
      subject { super().fetch('fstype') }

      it { is_expected.to be_kind_of(Argo::StringProperty) }

      it 'is not required' do
        expect(subject).not_to be_required
      end

      it 'has an enum constraint' do
        expect(subject.constraints).to eq(enum: %w[ ext3 ext4 btrfs ])
      end
    end

    describe 'options' do
      subject { super().fetch('options') }

      it { is_expected.to be_kind_of(Argo::ArrayProperty) }

      describe 'items' do
        subject { super().items }

        it { is_expected.to be_kind_of(Argo::StringProperty) }
      end

      it 'is not required' do
        expect(subject).not_to be_required
      end

      it 'has minimum items and uniqueness constraints' do
        expect(subject.constraints).to eq(
          min_items: 1,
          unique_items: true
        )
      end
    end

    describe 'readonly' do
      subject { super().fetch('readonly') }

      it { is_expected.to be_kind_of(Argo::BooleanProperty) }

      it 'is not required' do
        expect(subject).not_to be_required
      end
    end
  end
end
