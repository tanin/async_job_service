require 'rails_helper'

describe Commands::RunJobCmd do
  let(:uid) { Time.current.strftime("%H%M%S%L#{SecureRandom.random_number(100)}") }

  context 'when fails validation' do
    it 'raises exception if no queue_name passed' do
      cmd = described_class.new(uid: uid, data: { state: 'received', id: 123 })
      expect { cmd.validate! }.to raise_error(Commands::ValidationError)
    end

    it 'raises exception if no uid passed' do
      cmd = described_class.new(queue_name: 'email', data: { state: 'received', id: 123 })
      expect { cmd.validate! }.to raise_error(Commands::ValidationError)
    end

    it 'raises exception if no data passed' do
      cmd = described_class.new(uid: uid, queue_name: 'email')
      expect { cmd.validate! }.to raise_error(Commands::ValidationError)
    end
  end
end
