class Review < ApplicationRecord
  REVIEW_PARAMS = %i(rating comment).freeze
  belongs_to :reviewable, polymorphic: true
  belongs_to :user

  enum rating: {one_star: 1, two_stars: 2, three_stars: 3,
                four_stars: 4, five_stars: 5}

  validates :comment, presence: true,
             length: {maximum: Settings.max_comment_200}

  validates :rating, presence: true

  scope :recent, ->{order(created_at: :desc)}

  scope :with_rating, ->(rating){where(rating: ratings[rating])}
  scope :one_star, ->{with_rating(:one_star)}
  scope :two_stars, ->{with_rating(:two_stars)}
  scope :three_stars, ->{with_rating(:three_stars)}
  scope :four_stars, ->{with_rating(:four_stars)}
  scope :five_stars, ->{with_rating(:five_stars)}

  scope :average_rating, ->{average(:rating).to_f.round(1)}
end
