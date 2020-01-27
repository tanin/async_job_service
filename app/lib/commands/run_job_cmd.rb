module Commands
  class RunJobCmd < Base
    attr_accessor :uid, :queue_name, :data

    validates :uid, presence: true, allow_blank: false
    validates :queue_name, presence: true, allow_blank: false
    validates :data, presence: true, allow_blank: false

    def aggregate_uid
      uid
    end
  end
end
