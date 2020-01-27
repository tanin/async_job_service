module Events
  EmailReceived = Class.new(RailsEventStore::Event)
  StateChangedToError = Class.new(RailsEventStore::Event)
  JobFailed = Class.new(RailsEventStore::Event)
end
