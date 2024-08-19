class Product < ApplicationRecord
  PRODUCT_PARAMS = [:name, :description,
  :quantity_in_stock, :price_cents, :currency, :category_id, {images: []}]
                   .freeze
  belongs_to :category
  has_many :order_items, dependent: :destroy
  has_one :cart_item, dependent: :destroy
  has_one :discount, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many_attached :images

  monetize :price_cents, with_model_currency: :currency, allow_nil: true
  scope :order_by_name, ->{order :name}

  accepts_nested_attributes_for :category
end
