require 'rails_helper'

describe Denormalizers::Email::Received do
  let(:uid) { Time.current.strftime("%H%M%S%L#{SecureRandom.random_number(100)}") }

  describe '#perform' do
    context 'when success' do
      it 'creates email record' do
        payload = {
          "event_id" => "5a71ff1d-b6f1-4edb-986d-7eae0d3f573a",
          "data" => "---\n:state: received\n:id: 123\n:uid: #{uid}\n",
          "metadata" => "---\n:timestamp: 2020-01-27 01:04:23.400503522 Z\n",
          "event_type" => "Events::EmailReceived",
        }

        expect { described_class.new.perform(payload) }.to change(Email, :count).by(1)
      end
    end

    context 'when failed' do
      it 'fires JobFailed event and re-raises exception to move to retry queue' do
        email = create(:email, external_id: 123)

        payload = {
          "event_id" => "5a71ff1d-b6f1-4edb-986d-7eae0d3f573a",
          "data" => "---\n:state: received\n:id: 123\n:uid: #{uid}\n",
          "metadata" => "---\n:timestamp: 2020-01-27 01:04:23.400503522 Z\n",
          "event_type" => "Events::EmailReceived",
        }

        expect { described_class.new.perform(payload) }.to raise_error(ActiveRecord::RecordInvalid)

        expect(Rails.application.config.event_store).to have_published(
          an_event(Events::JobFailed).with_data(
            uid: uid,
            error_message: 'Validation failed: External has already been taken',
            status: 'error',
            queue_name: 'email',
            state: 'status'
          ),
          an_event(Events::StateChangedToError).with_data(state: 'error', error_message: 'Validation failed: External has already been taken')
        ).strict
      end
    end
  end
end
