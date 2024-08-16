class CartItemsController < ApplicationController
  def create
    @product = Product.find(params[:product_id])
    @cart = current_user.cart || current_user.create_cart
    @cart_item = @cart.cart_items.find_or_initialize_by(product: @product)

    if @cart_item.new_record?
      @cart_item.quantity = params[:quantity].to_i
      @cart_item.save
      flash[:success] = "Đã thêm vào giỏ hàng."
    else
      @cart_item.quantity += params[:quantity].to_i
      @cart_item.save
      flash[:info] = "Sản phẩm đã được cập nhật trong giỏ hàng."
    end

    redirect_to products_path
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Sản phẩm không tồn tại."
    redirect_to products_path
  end
end
