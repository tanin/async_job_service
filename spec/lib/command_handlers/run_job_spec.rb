require 'rails_helper'

describe CommandHandlers::RunJob do
  include Commands::Execute

  describe '#call' do
    let(:uid) { Time.current.strftime("%H%M%S%L#{SecureRandom.random_number(100)}") }

    context 'when success' do
      it 'Events::EmailReceived event published (integration)' do
        cmd = Commands::RunJob.new(uid: uid, state: 'status', queue_name: 'email', data: { status: 'received', id: 123 })
        execute(cmd)

        expect(Rails.application.config.event_store).to have_published(
          an_event(Events::EmailReceived).with_data(status: 'received', id: 123)
        ).strict
      end
    end

    context 'when fails' do
      it 'raises exception' do
        cmd = Commands::RunJob.new(uid: uid, queue_name: 'post', state: 'status', data: { status: 'received', id: 123 })

        expect { execute(cmd) }.to raise_error(NotImplementedError)

        expect(Rails.application.config.event_store).to_not have_published(
          an_event(Events::EmailReceived)
        ).strict
      end
    end
  end
end
