class PaymentMethod < ApplicationRecord
  has_many :orders, dependent: :destroy
  enum payment_method: {credit_card: 0, paypal: 1, bank_transfer: 2}

  validates :payment_method, presence: true

  def self.ransackable_attributes _auth_object
    %w(card_number created_at id payment_method updated_at)
  end
end
