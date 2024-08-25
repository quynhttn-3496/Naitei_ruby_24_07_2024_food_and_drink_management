class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  monetize :total_amount_cents, with_model_currency: :currency, allow_nil: true
end
