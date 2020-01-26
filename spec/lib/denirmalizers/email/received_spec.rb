require 'rails_helper'

describe Denormalizers::Email::Received do
  describe '#perform' do
    context 'when success' do
      it 'creates email record' do
        event = Events::EmailReceived.new(data: { action: 'received', id: 123 })

        payload = RubyEventStore::Mappers::Default.new.event_to_serialized_record(event)

        expect { described_class.new.perform(payload.to_h) }.to change(Email, :count).by(1)
      end
    end
  end
end
