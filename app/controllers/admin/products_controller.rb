class Admin::ProductsController < ApplicationController
  PRODUCT_PARAMS = [:name, :image_url, :description,
  :quantity_in_stock, :price_cents, :currency, {category_attributes: [:name]}]
                   .freeze
  def index
    @pagy, @products = pagy Product.order_by_name, limit: Settings.page_10

    @product = Product.new
    @product.build_category
  end

  # def new
  #   @product = Product.new
  #   @product.build_category
  # end
  def show
    @product = Product.find_by id: params[:id]
  end

  def create
    @product = Product.new product_params
    if @product.save
      redirect_to admin_products_path
    else
      frash[:error] = "loi roi"
    end
    @product.save
  end

  def edit; end

  def update; end

  def destroy; end

  private
  def product_params
    params.require(:product).permit(*PRODUCT_PARAMS)
  end
end
