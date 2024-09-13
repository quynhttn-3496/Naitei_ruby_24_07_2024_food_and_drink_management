FactoryBot.define do
  factory :review do
    comment { "This is a sample review" }
    rating { :three_stars }
    association :reviewable, factory: :product
    association :user
  end
end
