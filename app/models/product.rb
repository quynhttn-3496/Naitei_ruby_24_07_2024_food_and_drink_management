class Product < ApplicationRecord
  belongs_to :category
  has_one :order_items, dependent: :destroy
  has_one :cart_item, dependent: :destroy
  has_one :discount, dependent: :destroy
  has_many :reviews, dependent: :destroy, as: :reviewable

  monetize :price_cents, with_model_currency: :currency, allow_nil: true
  scope :order_by_name, ->{order :name}

  accepts_nested_attributes_for :category
end
