class Admin::ProductsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_admin!
  before_action :find_product, only: %i(edit update show destroy)
  before_action :get_category_all
  def index
    @q = Product.ransack(params[:q], auth_object: current_user)
    @pagy, @products = pagy @q.result, limit: Settings.page_10
    @category_names = Category.sorted_names
    @product = Product.new
  end

  def show; end

  def create
    @product = Product.new product_params

    if @product.save
      flash[:success] = t "product.create_success"
      redirect_to admin_products_path
    else
      respond_to(&:turbo_stream)
    end
  end

  def edit; end

  def update
    if @product.update product_params
      flash[:success] = t "product.updated_successfully"
      redirect_to admin_products_path
    else
      flash.now[:error] = t "product.update_failed"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      flash[:success] = t "product.admin_deleted"
    else
      flash[:danger] = t "product.admin_delete_fail"
    end
    redirect_to admin_products_path
  end

  private
  def product_params
    params.require(:product).permit(*Product::PRODUCT_PARAMS)
  end

  def find_product
    @product = Product.find_by id: params[:id]

    return if @product.present?

    flash[:error] = t "product.not_found"
    redirect_to admin_products_path and return false
  end

  def authenticate_admin!
    authorize! :manage, :admin_page
  end

  def get_category_all
    @categories = Category.by_name
  end
end
