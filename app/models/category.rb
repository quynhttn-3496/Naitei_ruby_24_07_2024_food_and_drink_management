class Category < ApplicationRecord
  has_many :products, dependent: :nullify

  scope :by_name, ->{order name: :asc}

  scope :sorted_names, ->{order(:name).pluck(:name)}

  def self.ransackable_attributes _auth_object
    %w(created_at id name updated_at)
  end
end
