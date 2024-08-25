class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  validates :user_id, presence: true

  def total_price
    cart_items.includes(:product).reduce(0) do |a, e|
      a + e.product.price * e.quantity
    end
  end
end
