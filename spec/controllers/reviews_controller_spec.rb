require "rails_helper"

RSpec.describe ReviewsController, type: :controller do
  let(:product) { create(:product) }
  let(:user) { create(:user) }
  let(:review_attributes) { attributes_for(:review, reviewable: product, user: user) }
  let(:review) { create(:review, reviewable: product, user: user) }
  let(:other_model) { create(:other_model) }

  before do
    sign_in user
  end

  describe "POST #create" do
    context "with valid attributes" do
      before do
        post :create, params: { product_id: product.id, review: review_attributes }, as: :turbo_stream
      end
    
      it "creates a new review" do
        expect {
          post :create, params: { product_id: product.id, review: review_attributes }, as: :turbo_stream
        }.to change(Review, :count).by(1)
      end
    
      it "returns a success response" do
        expect(response).to have_http_status(:success)
      end
    end
  
    context "with invalid attributes" do
      before do
        allow_any_instance_of(Review).to receive(:save).and_return(false)
      end

      it "does not create a new review" do
        expect {
          post :create, params: { product_id: product.id, review: review_attributes.merge(comment: nil) }, as: :turbo_stream
        }.not_to change(Review, :count)
      end

      it "renders the review partial" do
        post :create, params: { product_id: product.id, review: review_attributes.merge(comment: nil) }, as: :turbo_stream
        expect(response).to render_template("reviews/create")
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      before do
        patch :update, params: { product_id: product.id, id: review.id, review: { comment: "Updated comment" } }
      end
    
      it "updates the review" do
        review.reload
        expect(review.comment).to eq("Updated comment")
      end
    
      it "redirects to the reviewable" do
        expect(response).to redirect_to(reviewable_path(review.reviewable))
      end
    end 

    context "with invalid attributes" do
      before do
        patch :update, params: { product_id: product.id, id: review.id, review: { comment: "" } }
      end
      it "does not update the review when comment is empty" do
        review.reload
        expect(review.comment).not_to eq("")
      end
      
      it "redirects to the reviewable after failed update" do
        expect(response).to redirect_to(reviewable_path(review.reviewable))
      end
      
      it "sets the flash notice after failed update" do
        expect(flash[:notice]).to eq(I18n.t("reviews.update_failed"))
      end      
    end
  end

  describe "DELETE #destroy" do
    it "deletes the review" do
      review
      expect {
        delete :destroy, params: { product_id: product.id, id: review.id }
      }.to change(Review, :count).by(-1)
    end

    it "redirects to the reviewable" do
      delete :destroy, params: { product_id: product.id, id: review.id }
      expect(response).to redirect_to(reviewable_path(review.reviewable))
    end
  end

  private

  def reviewable_path(reviewable)
    case reviewable
    when Product
      product_path(reviewable)
    end
  end
end
