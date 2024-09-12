FactoryBot.define do
  factory :address do
    name { "John Doe" }
    address { "123 Main St" }
    phone { "1234567890" }
    association :user
  end
end
