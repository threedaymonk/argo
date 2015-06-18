require 'argo/parser'
require 'json'

RSpec.describe 'nfs' do
  # See http://json-schema.org/example2.html

  let(:root) {
    path = read_fixture('nfs.json')
    Argo::Parser.new(JSON.parse(path)).root
  }
  subject { root }

  it 'has no title' do
    expect(subject.title).to be_nil
  end

  describe 'properties' do
    subject { root.properties }

    it 'has three items' do
      expect(subject.length).to eq(3)
    end

    describe 'first' do
      subject { root.properties[0] }

      it { is_expected.to be_kind_of(Argo::StringProperty) }

      it 'has a name' do
        expect(subject.name).to eq('type')
      end

      it 'is required' do
        expect(subject).to be_required
      end

      it 'has constraints' do
        expect(subject.constraints).to eq(enum: %w[ nfs ])
      end
    end

    describe 'second' do
      subject { root.properties[1] }

      it { is_expected.to be_kind_of(Argo::StringProperty) }

      it 'has a name' do
        expect(subject.name).to eq('remotePath')
      end

      it 'is required' do
        expect(subject).to be_required
      end

      it 'has constraints' do
        expect(subject.constraints).to eq(pattern: '^(/[^/]+)+$')
      end
    end

    describe 'third' do
      subject { root.properties[2] }

      it { is_expected.to be_kind_of(Argo::StringProperty) }

      it 'has a name' do
        expect(subject.name).to eq('server')
      end

      it 'is required' do
        expect(subject).to be_required
      end

      it 'has constraints' do
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
