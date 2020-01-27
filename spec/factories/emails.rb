FactoryBot.define do
  factory :email do
    sequence(:external_id)
    data { { state: 'received' } }
  end
end
