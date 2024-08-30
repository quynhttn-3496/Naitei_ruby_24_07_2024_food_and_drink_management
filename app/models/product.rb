class Product < ApplicationRecord
  PRODUCT_PARAMS = [:name, :description,
  :quantity_in_stock, :price_cents, :currency, :category_id, {images: []}]
                   .freeze
  belongs_to :category
  has_many :order_items, dependent: :destroy
  has_one :cart_item, dependent: :destroy
  has_one :discount, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many_attached :images

  monetize :price_cents, with_model_currency: :currency, allow_nil: true
  scope :order_by_name, ->{order :name}

  accepts_nested_attributes_for :category
  scope :global_search, lambda {|query|
    return if query.blank?

    where("name LIKE :query OR description LIKE :query ", query: "%#{query}%")
  }

  scope :min_price, lambda {|price|
    where("price_cents >= ?", convert_to_vnd(price)) if price.present?
  }

  scope :max_price, lambda {|price|
    where("price_cents <= ?", convert_to_vnd(price)) if price.positive?
  }

  scope :filter_by_category_id, lambda {|category_id|
    where(category_id:) if category_id.present?
  }

  def self.convert_to_vnd price
    if I18n.locale == :en
      (price * Settings.exchange_rate_24).round
    else
      price
    end
  end
end
