require 'argo/parser'
require 'json'

RSpec.describe 'property reference' do
  subject {
    json = read_fixture('property_reference.json')
    Argo::Parser.new(JSON.parse(json)).root
  }

  describe 'a' do
    subject { super().properties.fetch('a') }

    it { is_expected.to be_kind_of(Argo::ObjectProperty) }

    it { is_expected.not_to be_required }

    describe 'one_of constraint' do
      subject { super().constraints.fetch(:one_of) }

      it 'has one entry' do
        expect(subject.length).to eq(1)
      end

      describe 'first' do
        subject { super().fetch(0) }

        it { is_expected.to be_kind_of(Argo::Schema) }

        describe 'properties' do
          subject { super().properties }

          describe 'type' do
            subject { super().fetch('type') }

            it { is_expected.to be_kind_of(Argo::StringProperty) }
          end
        end
      end
    end
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
