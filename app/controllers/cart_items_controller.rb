class CartItemsController < ApplicationController
  before_action :find_product, only: %i(create)
  before_action :find_cart_item, only: %i(update destroy)
  def create
    @cart = current_user.cart || current_user.create_cart
    @cart_item = @cart.cart_items.find_or_initialize_by product: @product

    handle_cart_item
    redirect_to products_path
  end

  def update
    if @cart_item.update cart_item_params
      render json: @cart_item, status: :ok
    else
      render json: @cart_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @cart_item.destroy
      flash[:success] = t "cart.deleted"
    else
      flash[:danger] = t "cart.deleted_fail"
    end
    redirect_to carts_path
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(*CartItem::CART_ITEM_PARAMS)
  end

  def find_product
    @product = Product.find_by id: params[:product_id]

    return if @product.present?

    flash[:error] = t "product.not_found"
    redirect_to products_path and return false
  end

  def find_cart_item
    @cart_item = CartItem.find_by id: params[:id]

    return if @cart_item.present?

    flash[:error] = t "cart.item_not_found"
    redirect_to carts_path and return false
  end

  def handle_cart_item
    if @cart_item.new_record?
      add_new_cart_item
    else
      update_existing_cart_item
    end
  end

  def add_new_cart_item
    @cart_item.quantity = params[*CartItem::CART_ITEM_PARAMS].to_i
    @cart_item.save
    flash[:success] = t "cart.added"
  end

  def update_existing_cart_item
    @cart_item.quantity += params[*CartItem::CART_ITEM_PARAMS].to_i
    @cart_item.save
    flash[:info] = t "cart.updated"
  end
end
