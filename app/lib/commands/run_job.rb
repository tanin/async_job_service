module Commands
  class RunJob < Base
    attr_accessor :uid # uid string generated from external id, always the same string for the same number
    attr_accessor :queue_name # queue_name string
    attr_accessor :state # state is the key of the data that represents an event name
    attr_accessor :data # data to be passed for the async processing, must include state key

    validates :uid, presence: true, allow_blank: false
    validates :state, presence: true, allow_blank: false
    validates :queue_name, presence: true, allow_blank: false
    validates :data, presence: true, allow_blank: false
    validate :data_integrity

    def aggregate_uid
      uid
    end

    protected

    def data_integrity
      return unless data && state

      raise ValidationError, "data must include #{state} key" unless data.keys.include?(state.to_sym)
    end
  end
end