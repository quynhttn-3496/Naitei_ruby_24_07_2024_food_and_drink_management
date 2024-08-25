class ProductsController < ApplicationController
  def index
    @products = Product.order_by_name
    @pagy, @products = pagy(Product.all, limit: Settings.page_10)
  end

  def show
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:warning] = t "product.not_found"
    redirect_to root_path
  end

  def new; end

  def create; end

  def edit; end

  def update; end
end
