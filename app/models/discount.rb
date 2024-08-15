class Discount < ApplicationRecord
  belongs_to :product

  enum status: {disabled: 0, enabled: 1}

  validates :discount_rate, presence: true
  validates :status, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
end
