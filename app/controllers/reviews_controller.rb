class ReviewsController < ApplicationController
  load_and_authorize_resource
  before_action :set_reviewable

  def create
    @review = @reviewable.reviews.build(review_params)
    @review.user = current_user
    @product = @reviewable
    if @review.save
      @pagy, @reviews = pagy(@product.reviews.recent, limit: Settings.reviews_5)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            "reviews-list",
            partial: "reviews/reviews_list",
            locals: {reviews: @reviews}
          )
        end
      end
    else
      @product = @reviewable
      respond_to(&:turbo_stream)
    end
  end

  def update
    @review = Review.find params[:id]
    authorize! :update, @review

    if @review.update(review_params)
      redirect_to @reviewable, notice: t("reviews.updated_success")
    else
      flash.now[:alert] = t "reviews.update_failed"
      render "#{@reviewable.model_name.plural}/edit"
    end
  end

  def destroy
    @review = Review.find params[:id]
    authorize! :destroy, @review

    @review.destroy
    redirect_to @reviewable, notice: t("reviews.deleted_success")
  end

  private

  def set_reviewable
    @reviewable = if params[:product_id]
                    Product.find(params[:product_id])
                  elsif params[:other_model_id]
                    OtherModel.find(params[:other_model_id])
                  end
  end

  def review_params
    params.require(:review).permit(Review::REVIEW_PARAMS)
  end
end
