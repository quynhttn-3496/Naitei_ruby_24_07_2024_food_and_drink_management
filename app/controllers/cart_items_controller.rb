class CartItemsController < ApplicationController
  def create
    @product = find_product params[:product_id]

    if @product
      @cart = current_user.cart || current_user.create_cart
      @cart_item = @cart.cart_items.find_or_initialize_by product: @product

      handle_cart_item
    else
      handle_product_not_found
    end

    redirect_to products_path
  end

  def destroy
    @cart_item = CartItem.find_by(id: params[:id])

    if @cart_item
      @cart_item.destroy
      flash[:success] = t("cart.deleted")
    else
      flash[:error] = t("cart.item_not_found")
    end

    redirect_to carts_path
  end

  private

  def find_product product_id
    Product.find_by(id: product_id)
  end

  def handle_cart_item
    if @cart_item.new_record?
      add_new_cart_item
    else
      update_existing_cart_item
    end
  end

  def handle_product_not_found
    flash[:error] = t("product.not_found")
  end

  def add_new_cart_item
    @cart_item.quantity = params[:quantity].to_i
    @cart_item.save
    flash[:success] = t "cart.added"
  end

  def update_existing_cart_item
    @cart_item.quantity += params[:quantity].to_i
    @cart_item.save
    flash[:info] = t "cart.updated"
  end
end
