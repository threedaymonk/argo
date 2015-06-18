require 'argo/parser'
require 'json'

RSpec.describe 'nfs' do
  # See http://json-schema.org/example2.html

  subject {
    json = read_fixture('nfs.json')
    Argo::Parser.new(JSON.parse(json)).root
  }

  it 'has no title' do
    expect(subject.title).to be_nil
  end

  describe 'properties' do
    subject { super().properties }

    it 'has three items' do
      expect(subject.length).to eq(3)
    end

    describe 'type' do
      subject { super().fetch('type') }

      it { is_expected.to be_kind_of(Argo::StringProperty) }

      it 'is required' do
        expect(subject).to be_required
      end

      it 'has an enum constraint' do
        expect(subject.constraints).to eq(enum: %w[ nfs ])
      end
    end

    describe 'remotePath' do
      subject { super().fetch('remotePath') }

      it { is_expected.to be_kind_of(Argo::StringProperty) }

      it 'is required' do
        expect(subject).to be_required
      end

      it 'has a pattern constraint' do
        expect(subject.constraints).to eq(pattern: '^(/[^/]+)+$')
      end
    end

    describe 'server' do
      subject { super().fetch('server') }

      it { is_expected.to be_kind_of(Argo::StringProperty) }

      it 'is required' do
        expect(subject).to be_required
      end

      it 'has a one-of constraint' do
        expect(subject.constraints).to eq(
          one_of: [
            { format: 'host-name' },
            { format: 'ipv4' },
            { format: 'ipv6' }
          ]
        )
      end
    end
  end
end
