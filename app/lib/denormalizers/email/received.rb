module Denormalizers
  module Email
    class Received < ActiveJob::Base
      queue_as :email

      # Handles only creation
      # if failed goes to rety queue for expection
      def perform(payload)
        event = event_store.deserialize(payload.symbolize_keys)

        external_id = event.data.delete(:id)

        ::Email.create!(
          data: event.data,
          external_id: external_id
        )
      end

      private

      def event_store
        Rails.configuration.event_store
      end
    end
  end
end
