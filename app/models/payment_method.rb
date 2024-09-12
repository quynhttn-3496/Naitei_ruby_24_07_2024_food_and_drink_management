class PaymentMethod < ApplicationRecord
  has_many :orders, dependent: :destroy
  enum payment_method: {bank_transfer: 0, credit_card: 1, paypal: 2}

  validates :payment_method, presence: true

  class << self
    def ransackable_attributes _auth_object
      %w(card_number created_at id payment_method updated_at)
    end

    def ransackable_associations _auth_object
      super + %w(order)
    end
  end
end
