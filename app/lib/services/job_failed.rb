module Services
  class JobFailed
    include Commands::Execute

    def call(event)
      cmd = Commands::FailJob.new(
        uid: event.data[:uid],
        queue_name: event.data[:queue_name],
        state: event.data[:state],
        data: event.data
      )

      execute(cmd)
    end

    private

    def event_store
      Rails.configuration.event_store
    end
  end
end
