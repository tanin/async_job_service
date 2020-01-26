class Email < ApplicationRecord
  validates :external_id, presence: true, uniqueness: true
  validates :data, presence: true
end
