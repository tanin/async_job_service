require 'rails_helper'

describe CommandHandlers::FailJob do
  include Commands::Execute

  describe '#call' do
    let(:uid) { Time.current.strftime("%H%M%S%L#{SecureRandom.random_number(100)}") }

    context 'when success' do
      it 'Events::StateChangedToError event published (integration)' do
        cmd = Commands::FailJob.new(uid: uid, queue_name: 'email', state: 'status', data: { status: 'error', error_message: 'some error' })
        execute(cmd)

        expect(Rails.application.config.event_store).to have_published(
          an_event(Events::StateChangedToError).with_data(state: 'error', error_message: 'some error')
        ).strict
      end
    end
  end
end
