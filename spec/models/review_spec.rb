require "rails_helper"

RSpec.describe Review, type: :model do
  describe "associations" do
    it { should belong_to(:reviewable) }
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:comment) }
    it { should validate_length_of(:comment).is_at_most(Settings.max_comment_200) }
    it { should validate_presence_of(:rating) }
  end

  describe "enums" do
    it "should define correct rating values" do
      expect(Review.ratings.keys).to contain_exactly("one_star", "two_stars", "three_stars", "four_stars", "five_stars")
      expect(Review.ratings.values).to contain_exactly(1, 2, 3, 4, 5)
    end
  end

  describe "scopes" do
    let!(:review1) { create(:review, rating: :three_stars, created_at: 1.day.ago) }
    let!(:review2) { create(:review, rating: :five_stars, created_at: 2.days.ago) }
    let!(:review3) { create(:review, rating: :one_star, created_at: 3.days.ago) }

    describe ".recent" do
      it "returns reviews in descending order of creation time" do
        expect(Review.recent).to eq([review1, review2, review3])
      end
    end

    describe ".with_rating" do
      it "returns reviews with specific rating" do
        expect(Review.with_rating(:three_stars)).to include(review1)
        expect(Review.with_rating(:three_stars)).not_to include(review2, review3)
      end
    end

    describe ".one_star" do
      it "returns reviews with one star rating" do
        expect(Review.one_star).to include(review3)
      end
    end

    describe ".average_rating" do
      it "returns the average rating of all reviews" do
        expect(Review.average_rating).to eq(3.0)
      end
    end
  end
end
