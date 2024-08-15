class User < ApplicationRecord
  enum role: {admin: 0, user: 1}

  has_one :cart, dependent: :destroy
  has_one :address, dependent: :destroy
  has_many :reviews, dependent: :destroy, as: :reviewable
  has_many :orders, dependent: :destroy

  accepts_nested_attributes_for :address
end
