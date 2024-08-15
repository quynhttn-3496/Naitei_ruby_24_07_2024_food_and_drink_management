class CreateDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :discounts do |t|
      t.references :product, null: false, foreign_key: true, unique: true
      t.decimal :discount_rate
      t.integer :status
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
