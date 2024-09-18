class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!
  def index
    @total_amount_this_month = Order.succeeded.current_month
                                    .sum :total_invoice_cents
    @revenue_change_percentage = Order.revenue_percentage_change

    @total_orders_this_month = Order.succeeded.count
    @order_count_change_percentage = Order.order_count_percentage_change

    @revenue_by_category_month = Order.joins(order_items: {product: :category})
                                      .group("categories.name")
                                      .group_by_month(:created_at)
                                      .sum(:total_invoice_cents)

    @products_by_category_revenue = Product.joins(:category)
                                           .group("categories.name")
                                           .count

    @monthly_revenue = Order.group_by_month(:created_at)
                            .sum(:total_invoice_cents)
  end

  private
  def authenticate_admin!
    authorize! :manage, :admin_page
  end
end
