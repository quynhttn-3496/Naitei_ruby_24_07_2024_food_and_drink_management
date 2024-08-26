class ReviewsController < ApplicationController
  before_action :set_reviewable

  def new
    @review = @reviewable.reviews.build
  end

  def create
    @review = @reviewable.reviews.build(review_params)
    # @review.user_id = current_user.id
    # binding.pry

    if @review.save
      redirect_to @reviewable, notice: t("review.created_success")
    else
      flash.now[:alert] = t("review.create_failed")
      render "products/show" # or the appropriate view for your `@reviewable` type
    end
  end

  private

  def set_reviewable
    @reviewable = if params[:product_id]
                    Product.find(params[:product_id])
                  elsif params[:other_model_id]
                    OtherModel.find(params[:other_model_id]) # Replace `OtherModel` with your actual model name
                  end
  end

  def review_params
    params.require(:review).permit(:rating, :comment, :product_id, :user_id)
  end
end
