class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user

  enum rating: {one_star: 1, two_stars: 2, three_stars: 3,
                four_stars: 4, five_stars: 5}
end
