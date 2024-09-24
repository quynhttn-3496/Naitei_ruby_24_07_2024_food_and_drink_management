FactoryBot.define do
  factory :order_item do
    association :order
    association :product
    quantity { 2 }
    total_amount_cents { 736_390 }
    total_amount_currency { "VND" }
    created_at { Time.now }
    updated_at { Time.now }
  end
end
