require 'argo/deferred_object'

RSpec.describe Argo::DeferredObject do
  subject { described_class.new { receiver.delegee } }
  let(:receiver) { double(delegee: delegee) }
  let(:delegee) { double(message: nil) }

  it 'does not call the block at initialization time' do
    expect(receiver).to receive(:delegee).never
    subject
  end

  it 'calls the block when a method is called' do
    expect(delegee).to receive(:message)
    subject.message
  end

  it 'delegates the value to the receiver' do
    allow(delegee).to receive(:message).and_return('VALUE')
    expect(subject.message).to eq('VALUE')
  end

  it 'evaluates the block only once' do
    expect(receiver).to receive(:delegee).once.and_return(delegee)
    2.times do
      subject.message
    end
  end
end
