class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_order, only: %i(update)

  def index
    @orders = Order.with_status(params[:status])
    render :index
  end

  def update
    return unless @order.confirming?

    case params[:type]
    when "accept"
      handle_accept_order
    when "cancel"
      handle_cancel_order
    end
  end

  private

  def handle_accept_order
    ActiveRecord::Base.transaction do
      process_success_order_items
      @order.succeeded!
      redirect_to admin_order_path(status: :succeeded),
                  notice: t("orders.acept_notice")
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to @order, alert: t("orders.cannot_accept_notice")
  end

  def handle_cancel_order
    ActiveRecord::Base.transaction do
      process_fail_order_items
      update_reason
      @order.failed!
      redirect_to admin_order_path(status: :failed),
                  notice: t("orders.destroy_notice")
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed
    redirect_to @order, alert: t("orders.cannot_destroy_notice")
  end

  def process_success_order_items
    ActiveRecord::Base.transaction do
      @order.order_items.each do |order_item|
        product = order_item.product
        product.delivery_quantity += order_item.quantity
        product.save!
      end
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to @order, alert: t("orders.cannot_process_items_notice")
  end
end
