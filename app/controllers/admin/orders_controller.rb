class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_order, only: :destroy

  def index
    @orders = Order.with_status(params[:status])
    render :index
  end

  def destroy
    if @order.confirming?
      ActiveRecord::Base.transaction do
        process_order_items
        @order.destroy!
      end
      redirect_to root_path, notice: t("orders.destroy_notice")
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed
    redirect_to @order, alert: t("orders.cannot_destroy_notice")
  end

  private

  def process_order_items
    ActiveRecord::Base.transaction do
      @order.order_items.each do |order_item|
        product = order_item.product
        product.quantity_in_stock += order_item.quantity
        product.save!
      end
    end
  end
end
