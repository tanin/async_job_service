module CommandHandlers
  class RunJob < CommandHandlers::Base
    def call(command)
      with_aggregate(Domain::RunJob, command.aggregate_uid, command.queue_name) do |run_job|
        run_job.create(command.data, command.state)
      end
    end
  end
end
