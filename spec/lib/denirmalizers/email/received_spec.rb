require 'rails_helper'

describe Denormalizers::Email::Received do
  describe '#perform' do
    context 'when success' do
      it 'creates email record' do
        payload = {
          "event_id" => "5a71ff1d-b6f1-4edb-986d-7eae0d3f573a",
          "data" => "---\n:state: received\n:id: 123\n",
          "metadata" => "---\n:timestamp: 2020-01-27 01:04:23.400503522 Z\n",
          "event_type" => "Events::EmailReceived",
        }

        expect { described_class.new.perform(payload) }.to change(Email, :count).by(1)
      end
    end
  end
end
