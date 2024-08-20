class CartsController < ApplicationController
  def show
    if current_user.present?
      @cart = current_user.cart
      @cart_items = @cart.cart_items.includes(:product)
    else
      redirect_to login_path
    end
  end
end
