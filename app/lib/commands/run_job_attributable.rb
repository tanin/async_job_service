module Commands
  module RunJobAttributable
    def self.included(base)
      base.class_eval do
        attr_accessor :uid # string
        attr_accessor :queue_name # string
        attr_accessor :state # the key of the data that represents an event name
        attr_accessor :data # data to be passed for the async processing, must include state key

        validates :uid, presence: true, allow_blank: false
        validates :state, presence: true, allow_blank: false
        validates :queue_name, presence: true, allow_blank: false
        validates :data, presence: true, allow_blank: false
        validate :data_integrity
      end
    end

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
