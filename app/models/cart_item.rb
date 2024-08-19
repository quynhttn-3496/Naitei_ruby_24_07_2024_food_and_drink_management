class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, presence: true,
             numericality: {greater_than_or_equal_to: 1}

  scope :by_product, ->(product_id){where(product_id:)}
end
