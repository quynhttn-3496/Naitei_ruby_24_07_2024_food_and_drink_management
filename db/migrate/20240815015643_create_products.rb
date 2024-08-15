class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.integer :delivery_quantity
      t.string :image_url
      t.string :description
      t.integer :quantity_in_stock
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
