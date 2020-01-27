module Denormalizers
  module Email
    class Received < ActiveJob::Base
      queue_as :email

      # Handles only creation
      # goes to rety queue for inspection if failed
      def perform(payload)
        event = event_store.deserialize(payload.deep_symbolize_keys)
        external_id = event.data.delete(:id)

        ::Email.create!(
          data: event.data,
          external_id: external_id
        )

      rescue StandardError => e
        publish_error_event(event.data[:uid], e.message)
        raise e
      end

      private

      def publish_error_event(uid, message)
        event = Events::JobFailed.new(
          data: {
            uid: uid.to_s,
            error_message: message,
            status: 'error',
            queue_name: 'email',
            state: 'status'
          }
        )

        event_store.publish(event)
      end

      def event_store
        Rails.configuration.event_store
      end
    end
  end
end
