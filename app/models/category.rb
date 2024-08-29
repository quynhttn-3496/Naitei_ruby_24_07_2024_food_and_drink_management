class Category < ApplicationRecord
  has_many :products, dependent: :nullify

  scope :by_name, ->{order name: :asc}
end
