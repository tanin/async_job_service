class Domain::RunJob
  include AggregateRoot

  InErrorStateError = Class.new(StandardError)
  JobAlreadyExists = Class.new(StandardError)

  attr_reader :uid, :queue_name, :data, :state, :error_message

  def initialize(uid, queue_name)
    @uid = uid
    @queue_name = queue_name
  end

  def create(data, state)
    raise InErrorStateError if error?
    raise JobAlreadyExists, 'job already exists' unless valid_state?(data[state.to_sym])

    event_klass = event_klass(data[state.to_sym])

    define_apply_method(event_klass)

    apply(event_klass.new(data: data.merge(state: state.to_sym, uid: uid)))
  end

  def error(error_message)
    apply(Events::StateChangedToError.new(data: { state: 'error', error_message: error_message }))
  end

  def event_klass(state)
    "Events::#{queue_name.camelize}#{state.camelize}".constantize
  rescue NoMethodError, NameError
    @state = 'error'
    @error_message = 'service is not able to apply this request'
    raise NotImplementedError, @error_message
  end

  # defines apply method for applyed event
  def define_apply_method(event_klass)
    define_singleton_method(
      apply_method_name(event_klass),
      ->(event) {
        @data = event.data
        @state = event.data[event.data[:state]]
      }
    )
  end

  def apply_method_name(event_klass)
    "apply_#{event_klass.to_s.split('::').second.underscore}".to_sym
  end

  # Overwriting default apply_strategy
  # to redefine apply methods on aggregate root load
  def apply_strategy
    ->(aggregate, event) do
      method_name = apply_method_name(event.class)

      return send(method_name, event) if aggregate.respond_to?(method_name)

      aggregate.define_apply_method(event.class)

      { event.class => method(method_name) }.fetch(event.class, ->(event) { raise }).call(event)
    end
  end

  def apply_state_changed_to_error(event)
    @state = event.data[:state]
    @error_message = event.data[:error_message]
  end

  def error?
    state == 'error'
  end

  def valid_state?(new_state)
    state != new_state
  end
end
