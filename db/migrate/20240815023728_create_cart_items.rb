class CreateCartItems < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_items do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true, unique: true
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
