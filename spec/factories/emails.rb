FactoryBot.define do
  factory :email do
    sequence(:external_id)
    data { { action: 'received' } }
  end
end
