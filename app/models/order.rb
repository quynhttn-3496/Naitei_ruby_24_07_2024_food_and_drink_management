class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  belongs_to :user
  belongs_to :payment_method
  belongs_to :address

  enum status: {failed: 0, succecced: 1, confirming: 2}
  accepts_nested_attributes_for :address, :payment_method, :order_items

  monetize :total_invoice_cents, with_model_currency: :currency, allow_nil: true

  ORDER_PARAMS = [:total_invoice_cents, :total_invoice_currency,
                  {address_attributes: [:user_id, :name, :address, :phone],
                   payment_method_attributes: [:payment_method],
                   order_items_attributes: [:product_id, :quantity,
:total_amount]}].freeze
end
