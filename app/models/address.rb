class Address < ApplicationRecord
  belongs_to :user
  has_many :orders, dependent: :nullify

  validates :name, :address, :phone, presence: true
end
