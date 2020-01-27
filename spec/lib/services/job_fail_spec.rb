require 'rails_helper'

describe Services::JobFailed do
  let(:uid) { Time.current.strftime("%H%M%S%L#{SecureRandom.random_number(100)}") }

  describe '#call' do
    context 'when success' do
      it 'updates aggregate root' do
        event = Events::JobFailed.new(
          data: {
            uid: uid,
            error_message: 'Validation failed: External has already been taken',
            status: 'error',
            queue_name: 'email',
            state: 'status'
          }
        )

        described_class.new.call(event)

        expect(Rails.application.config.event_store).to have_published(
          an_event(Events::StateChangedToError).with_data(
            state: 'error',
            error_message: 'Validation failed: External has already been taken'
          )
        ).strict
      end
    end
  end
end
