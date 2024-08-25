class OrdersController < ApplicationController
  before_action :handle_not_login

  def index; end

  def new
    @order = Order.new
    @order.build_address
    @order.build_payment_method
    @order.order_items.build

    @cart = current_user.cart
    @cart_items = @cart.cart_items.includes(:product)
  end

  def create # rubocop:disable Metrics/AbcSize
    ActiveRecord::Base.transaction do
      @order = Order.new order_params
      @order.status = :confirming
      @order.user_id = current_user.id

      if @order.save
        @order.order_items.each do |order_item|
          product = order_item.product
          product.quantity_in_stock -= order_item.quantity
          product.save!

          current_user.cart.cart_items.where(product_id: order_item.product_id).destroy_all # rubocop:disable Layout/LineLength
        end
        flash[:success] = t "order.success"
        redirect_to orders_path
      else
        raise ActiveRecord::Rollback
        render :new # rubocop:disable Lint/UnreachableCode
      end
    end
  end

  def show
    @cart = current_user.cart
    @cart_items = @cart.cart_items.includes(:product)
  end

  private

  def order_params
    params.require(:order).permit(:total_invoice_cents, :total_invoice_currency,
                                  address_attributes: [:user_id, :name,
:address, :phone],
                                  payment_method_attributes: [:payment_method],
                                  order_items_attributes: [:product_id,
:quantity, :total_amount])
  end

  def handle_not_login
    return if current_user

    redirect_to login_path
  end
end
