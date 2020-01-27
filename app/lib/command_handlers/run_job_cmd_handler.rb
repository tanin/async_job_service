module CommandHandlers
  class RunJobCmdHandler < CommandHandlers::Base
    def call(command)
      with_aggregate(Domain::RunJob, command.aggregate_uid, command.queue_name) do |run_job|
        run_job.create(command.data)
      end
    end
  end
end
