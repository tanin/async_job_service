require 'rails_helper'

describe Commands::FailJob do
  let(:uid) { Time.current.strftime("%H%M%S%L#{SecureRandom.random_number(100)}") }

  it 'is valid command' do
    cmd = described_class.new(uid: uid, queue_name: 'email', state: 'status', data: { status: 'error', error_message: 'some error' })
    expect(cmd).to be_valid
  end

  context 'when fails validation' do
    it 'raises exception if no queue_name passed' do
      cmd = described_class.new(uid: uid, state: 'status', data: { status: 'error', error_message: 'some error' })
      expect { cmd.validate! }.to raise_error(Commands::ValidationError)
    end

    it 'raises exception if no state passed' do
      cmd = described_class.new(uid: uid, queue_name: 'email', data: { status: 'error', error_message: 'some error' })
      expect { cmd.validate! }.to raise_error(Commands::ValidationError)
    end

    it 'raises exception if no uid passed' do
      cmd = described_class.new(queue_name: 'email', state: 'status',  data: { status: 'error', error_message: 'some error' })
      expect { cmd.validate! }.to raise_error(Commands::ValidationError)
    end

    it 'raises exception if no data passed' do
      cmd = described_class.new(uid: uid, queue_name: 'email', state: 'status', )
      expect { cmd.validate! }.to raise_error(Commands::ValidationError)
    end

    it 'raise error if data does not contains status key' do
      cmd = described_class.new(uid: uid, queue_name: 'email', state: 'status',  data: { foo: 'error', error_message: 'some error' })
      expect { cmd.validate! }.to raise_error(Commands::ValidationError)
    end
  end
end
