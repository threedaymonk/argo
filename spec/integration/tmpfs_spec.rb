require 'argo/parser'
require 'json'

RSpec.describe 'tmpfs' do
  # See http://json-schema.org/example2.html

  subject {
    json = read_fixture('tmpfs.json')
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

      it 'has constraints' do
        expect(subject.constraints).to eq(enum: %w[ tmpfs ])
      end
    end

    describe 'sizeInMB' do
      subject { super().fetch('sizeInMB') }

      it { is_expected.to be_kind_of(Argo::IntegerProperty) }

      it 'is required' do
        expect(subject).to be_required
      end

      it 'has constraints' do
        expect(subject.constraints).to eq(minimum: 16, maximum: 512)
      end
    end
  end
end
