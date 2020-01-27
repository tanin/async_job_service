class Domain::RunJob
  include AggregateRoot

  attr_reader :uid, :queue_name, :data, :state

  def initialize(uid, queue_name)
    @uid = uid
    @queue_name = queue_name
  end

  def create(data)
    event_klass = event_klass(data[:state])

    define_apply_method(event_klass)

    apply(event_klass.new(data: data))
  end

  protected

  def event_klass(action)
    "Events::#{queue_name.camelize}#{action.camelize}".constantize
  rescue NoMethodError, NameError
    raise NotImplementedError, 'service is not able to apply this request'
  end

  # defines apply method for applyed event
  def define_apply_method(event_klass)
    define_singleton_method(
      "apply_#{event_klass.to_s.split('::').second.underscore}".to_sym,
      ->(event) {
        @data = event.data
        @state = event.data[:state]
      }
    )
  end
end
