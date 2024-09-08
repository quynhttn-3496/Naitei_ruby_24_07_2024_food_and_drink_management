class RemoveProductIdFromReviews < ActiveRecord::Migration[7.0]
  def change
    remove_column :reviews, :product_id, :integer
  end
end
