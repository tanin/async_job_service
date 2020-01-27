class Domain::RunJob
  include AggregateRoot

  InErrorStateError = Class.new(StandardError)

  attr_reader :uid, :queue_name, :data, :state, :error_message

  def initialize(uid, queue_name)
    @uid = uid
    @queue_name = queue_name
  end

  def create(data, state)
    raise InErrorStateError if error?

    event_klass = event_klass(data[state.to_sym])

    define_apply_method(event_klass)

    apply(event_klass.new(data: data.merge(state: state.to_sym)))
  end

  def error(error_message)
    @state = 'error'
    @error_message = error_message
    apply(Events::StateChangedToError.new(data: { state: 'error', error_message: error_message }))
  end

  protected

  def event_klass(action)
    "Events::#{queue_name.camelize}#{action.camelize}".constantize
  rescue NoMethodError, NameError
    @state = 'error'
    @error_message = 'service is not able to apply this request'
    raise NotImplementedError, @error_message
  end

  # defines apply method for applyed event
  def define_apply_method(event_klass)
    define_singleton_method(
      "apply_#{event_klass.to_s.split('::').second.underscore}".to_sym,
      ->(event) {
        @data = event.data
        @state = event.data[event.data[:state]]
      }
    )
  end

  def apply_state_changed_to_error(event)
    @state = event.data[:state]
    @error_message = event.data[:error_message]
  end

  def error?
    state == 'error'
  end
end
