module CommandHandlers
  class FailJob < CommandHandlers::Base
    def call(command)
      with_aggregate(Domain::RunJob, command.aggregate_uid, command.queue_name) do |run_job|
        run_job.error(command.data[:error_message])
      end
    end
  end
end
