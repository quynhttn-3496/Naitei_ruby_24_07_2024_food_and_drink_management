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

  def create
    ActiveRecord::Base.transaction do
      build_order
      raise ActiveRecord::Rollback unless @order.save

      process_order_items
      flash[:success] = t "order.success"
      redirect_to orders_path
    end
  end

  def show
    @cart = current_user.cart
    @cart_items = @cart.cart_items.includes(:product)
  end

  private

  def order_params
    params.require(:order).permit(*Order::ORDER_PARAMS)
  end

  def handle_not_login
    return if current_user

    redirect_to login_path
  end

  def build_order
    @order = Order.new order_params
    @order.status = :confirming
    @order.user_id = current_user.id
  end

  def process_order_items
    ActiveRecord::Base.transaction do
      @order.order_items.each do |order_item|
        product = order_item.product
        product.quantity_in_stock -= order_item.quantity
        product.save!

        current_user.cart.cart_items.by_product(order_item.product_id)
                    .destroy_all
      end
    end
  end
end
