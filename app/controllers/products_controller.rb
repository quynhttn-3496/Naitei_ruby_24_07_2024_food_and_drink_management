class ProductsController < ApplicationController
  def index
    @products = Product.order :name
  end

  def show
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:warning] = t "product.not_found"
  end

  def new; end

  def create; end
end
