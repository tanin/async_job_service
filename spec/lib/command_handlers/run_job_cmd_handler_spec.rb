require 'rails_helper'

describe CommandHandlers::RunJobCmdHandler do
  include Commands::Execute

  describe '#call' do
    context 'when success' do
      it 'Events::EmailReceived event published (integration)' do
        uid = Time.current.strftime("%H%M%S%L#{SecureRandom.random_number(100)}")

        cmd = Commands::RunJobCmd.new(uid: uid, queue_name: 'email', data: { state: 'received', id: 123 })
        execute(cmd)

        expect(Rails.application.config.event_store).to have_published(
          an_event(Events::EmailReceived).with_data(state: 'received', id: 123)
        ).strict
      end
    end

    context 'when fails' do
      context 'validations' do

      end

      context 'worker not implemented' do

      end
    end
  end
end
