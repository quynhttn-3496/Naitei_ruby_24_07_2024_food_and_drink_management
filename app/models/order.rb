class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  belongs_to :user
  belongs_to :payment_method
  belongs_to :address

  enum status: {failed: 0, succecced: 1, confirming: 2}
  accepts_nested_attributes_for :address, :payment_method, :order_items

  monetize :total_invoice_cents, with_model_currency: :currency, allow_nil: true
end
