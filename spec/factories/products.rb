FactoryBot.define do
  factory :product do
    name { "Sample Product" }
    price_cents { 10000 }
    quantity_in_stock { 10 }
    association :category
    currency { "USD" }
    delivery_quantity { 0 }
  end
end
