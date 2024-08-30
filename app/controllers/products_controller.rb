class ProductsController < ApplicationController
  def index
    apply_filters
    paginate_products
  end

  def show
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:warning] = t "product.not_found"
    redirect_to root_path
  end

  private

  def apply_filters
    @products = @products.oder_by_name.global_search(params.dig(:search,
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
