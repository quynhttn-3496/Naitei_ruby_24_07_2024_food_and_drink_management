class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  belongs_to :user
  belongs_to :payment_method
  belongs_to :address

  enum status: {failed: 0, succecced: 1}
end
