class Api::V1::ReviewsController < Api::V1::ApplicationController
  before_action :authenticate_user
  before_action :set_product
  before_action :set_review, only: %i(show update destroy)

  def index
    @reviews = @product.reviews
    if @reviews.any?
      render json: {reviews: @reviews}, status: :ok
    else
      render json: {message: I18n.t("messages.review.no_reviews_found")},
             status: :ok
    end
  end

  def show
    if @review
      render json: {review: @review}, status: :ok
    else
      render json: {message: I18n.t("messages.review.not_found")},
             status: :not_found
    end
  end

  def create
    @review = @product.reviews.new review_params.merge(user: current_user)
    if @review.save
      render json: {message: I18n.t("messages.review.created_successfully"),
                    review: @review}, status: :created
    else
      render json: {message: I18n.t("messages.review.failed_to_create"),
                    errors: @review.errors.full_messages},
             status: :unprocessable_entity
    end
  end

  def update
    if @review.user == current_user
      if @review.update review_params
        render json: {message: I18n.t("messages.review.updated_successfully"),
                      review: @review}, status: :ok
      else
        render json: {message: I18n.t("messages.review.failed_to_update"),
                      errors: @review.errors.full_messages},
               status: :unprocessable_entity
      end
    else
      render json: {message: I18n.t("messages.review.not_authorized")},
             status: :forbidden
    end
  end

  def destroy
    if @review.user == current_user
      if @review.destroy
        render json: {message: I18n.t("messages.review.deleted_successfully")},
               status: :ok
      else
        render json: {message: I18n.t("messages.review.failed_to_delete")},
               status: :unprocessable_entity
      end
    else
      render json: {message: I18n.t("messages.review.not_authorized")},
             status: :forbidden
    end
  end

  private

  def set_product
    @product = Product.find_by id: params[:product_id]
    return if @product

    render json: {message: I18n.t("messages.product.not_found")},
           status: :not_found
  end

  def set_review
    @review = @product.reviews.find_by id: params[:id]
    return if @review

    render json: {message: I18n.t("messages.review.not_found")},
           status: :not_found
  end

  def review_params
    params.require(:review).permit Review::REVIEW_PARAMS
  end
end
