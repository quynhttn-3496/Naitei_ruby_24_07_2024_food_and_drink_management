class ProductsController < ApplicationController
  authorize_resource
  def index
    if params[:query].present?
      @products = Product.search(params[:query]).records
    else
      @products = Product.all
    end
    # apply_filters
    # paginate_products
  end

  def show
    @product = Product.find_by id: params[:id]
    unless @product
      return redirect_to root_path, warning: t("product.not_found")
    end

    @pagy, @reviews = pagy(@product.reviews.recent, limit: Settings.reviews_5)
  end

  private

  def apply_filters
    @products = Product.order_by_name.global_search(params.dig(:search,
                                                               :query))
                       .min_price(params.dig(:search, :price_min).to_d)
                       .max_price(params.dig(:search, :price_max).to_d)
                       .filter_by_category_id(
                         params.dig(:search, :category_id)
                       )
  end

  def paginate_products
    @pagy, @products = pagy(@products, limit: Settings.page_10)
  end
end
