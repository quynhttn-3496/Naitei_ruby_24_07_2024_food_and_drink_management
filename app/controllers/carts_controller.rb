class CartsController < ApplicationController
  def index; end

  def show
    if current_user
      @cart = current_user.cart
      if @cart
        @cart_items = @cart.cart_items.includes(:product)
      else
        @cart_items = []
        flash[:alert] = t("cart.empty")
        redirect_to products_path
      end
    else
      redirect_to new_user_session_path
    end
  end
end
