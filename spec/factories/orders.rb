FactoryBot.define do
  factory :order do
    total_invoice_cents { 10000 }
    total_invoice_currency { "USD" }
    reason { "Sample reason" }
    status { :succeeded }
    association :user
    association :payment_method
    association :address
  end
end
