module Commands
  module Execute
    def execute(command)
      command.validate!
      handler_for(command).call(command)
    end

    private

    def handler_for(command)
      {
        Commands::RunJobCmd => CommandHandlers::RunJobCmdHandler.new,
      }.fetch(command.class)
    end
  end
end