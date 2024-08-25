class ReviewsController < ApplicationController
  before_action :set_product

  def new
    @review = @product.reviews.build
  end

  def create
    @review = @product.reviews.build(review_params)
    @review.user = current_user # Nếu bạn có thông tin người dùng hiện tại

    if @review.save
      redirect_to @product, notice: t("review.created_success")
    else
      flash.now[:alert] = t("review.create_failed")
      render "products/show"
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
