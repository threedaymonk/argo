require 'argo/immutable_keyword_struct'

RSpec.describe Argo::ImmutableKeywordStruct do
  let(:klass) {
    described_class.new(a: nil, b: 'foo') do
      def hello
        "hello #{b}"
      end
    end
  }

  context 'with defaults' do
    subject { klass.new }

    it 'assigns properties with defaults' do
      expect(subject.a).to be_nil
      expect(subject.b).to eq('foo')
    end

    it 'freezes values' do
      expect {
        subject.b << ' oops'
      }.to raise_exception(RuntimeError)
    end

    it 'allows method definition in a block' do
      expect(subject.hello).to eq('hello foo')
    end
  end

  context 'with assigned values' do
    subject { klass.new(b: 'bar') }

    it 'overrides defaults' do
      expect(subject.b).to eq('bar')
    end

    it 'freezes values' do
      expect {
        subject.b << ' oops'
      }.to raise_exception(RuntimeError)
    end

    it 'allows method definition in a block' do
      expect(subject.hello).to eq('hello bar')
    end
  end

  it 'raises an exception with an unrecognised keyword' do
    expect {
      klass.new(c: 1)
    }.to raise_exception(ArgumentError)
  end
end
