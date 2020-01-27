Rails.application.config.event_store.tap do |es|
  es.subscribe(Denormalizers::Email::Received, to: [Events::EmailReceived])
  es.subscribe(Services::JobFailed, to: [Events::JobFailed])
end
