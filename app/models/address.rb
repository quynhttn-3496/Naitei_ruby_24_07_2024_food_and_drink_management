class Address < ApplicationRecord
  belongs_to :user
  has_many :orders, dependent: :nullify

  validates :name, :address, :phone, presence: true

  class << self
    def ransackable_attributes _auth_object
      %w(id phone address name)
    end

    def ransackable_associations _auth_object
      %w(orders)
    end
  end
end
