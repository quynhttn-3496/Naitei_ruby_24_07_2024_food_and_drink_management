class Order < ApplicationRecord
  ORDER_PARAMS = [:total_invoice_cents, :total_invoice_currency, :reason,
                  {address_attributes: [:user_id, :name, :address, :phone],
                   payment_method_attributes: [:payment_method],
                   order_items_attributes: [:product_id, :quantity,
    :total_amount]}].freeze

  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items
  belongs_to :user
  belongs_to :payment_method
  belongs_to :address

  enum status: {failed: 0, succeeded: 1, confirming: 2, rejected: 3}

  accepts_nested_attributes_for :address, :payment_method, :order_items
  monetize :total_invoice_cents, with_model_currency: :currency, allow_nil: true

  scope :with_status, ->(status){where(status:) if status.present?}
  scope :for_user, ->(user_id){where(user_id:) if user_id.present?}
  scope :current_month, lambda {|_x = nil|
    start_of_month = Time.current.beginning_of_month
    end_of_month = Time.current.end_of_month
    where created_at: start_of_month..end_of_month
  }

  scope :previous_month, lambda {|_x = nil|
    start_of_last_month = Time.current.last_month.beginning_of_month
    end_of_last_month = Time.current.last_month.end_of_month
    where created_at: start_of_last_month..end_of_last_month
  }

  class << self
    def revenue_percentage_change
      current_month_revenue = succeeded.current_month.sum :total_invoice_cents
      previous_month_revenue = succeeded.previous_month.sum :total_invoice_cents

      return 100 if previous_month_revenue.zero?

      percentage_change = ((current_month_revenue - previous_month_revenue) /
                              previous_month_revenue.to_f) * 100
      percentage_change.round(2)
    end

    def order_count_percentage_change
      current_month_orders = current_month.count
      previous_month_orders = previous_month.count

      return 100 if previous_month_orders.zero?

      percentage_change = ((current_month_orders - previous_month_orders) /
                                previous_month_orders.to_f) * 100
      percentage_change.round(2)
    end
  end
end
