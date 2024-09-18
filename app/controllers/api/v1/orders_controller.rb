class Api::V1::OrdersController < Api::V1::ApplicationController
  before_action :authenticate_admin
  before_action :set_order, only: %i(update show)

  def index
    @q = Order.joins(:payment_method).ransack(params[:q])
    @pagy, @orders = pagy(
      @q.result.with_status(params[:status]),
      limit: Settings.page_5
    )

    render json: {
      orders: ActiveModelSerializers::SerializableResource
        .new(@orders, each_serializer: OrderSerializer),
      pagy: {
        page: @pagy.page,
        items: @pagy.vars[:limit],
        pages: @pagy.pages
      }
    }, status: :ok
  end

  def show
    if @order
      render json: {order: @order}, status: :ok
    else
      render json: {message: I18n.t("messages.order.not_found")},
             status: :not_found
    end
  end

  def update
    return unless @order.confirming?

    case params[:type]
    when "accept"
      handle_accept_order
    when "cancel"
      handle_cancel_order
    else
      render json: {message: I18n.t("messages.order.invalid_action")},
             status: :unprocessable_entity
    end
  end

  private

  def handle_accept_order
    ActiveRecord::Base.transaction do
      process_success_order_items
      @order.succeeded!
      render json: {message: I18n.t("orders.accept_notice"), order: @order},
             status: :ok
    end
  rescue ActiveRecord::RecordInvalid
    render json: {message: I18n.t("orders.cannot_accept_notice")},
           status: :unprocessable_entity
  end

  def handle_cancel_order
    ActiveRecord::Base.transaction do
      process_fail_order_items
      update_reason
      @order.failed!
      render json: {message: I18n.t("orders.destroy_notice"), order: @order},
             status: :ok
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed
    render json: {message: I18n.t("orders.cannot_destroy_notice")},
           status: :unprocessable_entity
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
    render json: {message: I18n.t("orders.cannot_process_items_notice")},
           status: :unprocessable_entity
  end
end
