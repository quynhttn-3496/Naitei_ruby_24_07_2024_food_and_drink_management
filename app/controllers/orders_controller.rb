class OrdersController < ApplicationController
  before_action :handle_not_login
  before_action :authenticate_user!
  before_action :check_admin, only: :index
  before_action :set_order, only: %i(update)

  def index
    @orders = Order.with_status(params[:status]).for_user(current_user)
    render :index
  end

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
      redirect_to orders_path(status: :confirming)
    end
  end

  def show
    @cart = current_user.cart
    @cart_items = @cart.cart_items.includes(:product)
  end

  def update
    if @order.confirming?
      ActiveRecord::Base.transaction do
        process_fail_order_items
        update_reason
        @order.rejected!
      end
      redirect_to root_path, notice: t("orders.destroy_notice")
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed
    redirect_to @order, alert: t("orders.cannot_destroy_notice")
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

  def authenticate_user!
    return if logged_in?

    redirect_to root_path, alert: t("not_signed")
  end

  def check_admin
    return unless current_user.admin?

    redirect_to admin_orders_path
  end
end
