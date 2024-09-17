class Api::V1::ApplicationController < ActionController::API
  include Pagy::Backend
  attr_reader :current_user
  private

  def encode_token payload
    JWT.encode(payload, "salt")
  end

  def decode_token
    auth_header = request.headers["Authorization"]
    return nil unless auth_header

    token = auth_header.split(" ")[1]
    begin
      JWT.decode(token, "salt", true, algorithm: "HS256")
    rescue JWT::DecodeError
      nil
    end
  end

  def authenticate_user
    decoded_token = decode_token
    user_id = decoded_token[0]["user_id"] if decoded_token
    @current_user = User.find_by(id: user_id) if user_id

    return if @current_user

    render json: {message: "Please log in"}, status: :unauthorized
  end

  def set_order
    @order = Order.find_by id: params[:id]
    return if @order

    render json: {message: I18n.t("messages.order.not_found")},
           status: :not_found
  end

  def authenticate_admin
    authenticate_user
    return if current_user&.admin?

    render json: {message: I18n.t("not_admin")}, status: :forbidden
  end

  def update_reason
    ActiveRecord::Base.transaction do
      reason = params.dig(:order, :reason)
      if reason.present?
        @order.update!(reason:)
      else
        render json: {message: I18n.t("orders.no_reason_provided")},
               status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid
    render json: {message: I18n.t("orders.cannot_update_reason")},
           status: :unprocessable_entity
  end

  def process_fail_order_items
    ActiveRecord::Base.transaction do
      @order.order_items.each do |order_item|
        product = order_item.product
        product.quantity_in_stock += order_item.quantity
        product.save!
      end
    end
  rescue ActiveRecord::RecordInvalid
    render json: {message: I18n.t("orders.cannot_update_reason")},
           status: :unprocessable_entity
  end
end
