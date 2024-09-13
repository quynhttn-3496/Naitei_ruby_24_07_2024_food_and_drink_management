FactoryBot.define do
  factory :user do
    username { "Sample User" }
    sequence(:email) { |n| "user#{n}@gmail.com" }
    password { "password" }
    confirmed_at {Time.now}
  end
end
