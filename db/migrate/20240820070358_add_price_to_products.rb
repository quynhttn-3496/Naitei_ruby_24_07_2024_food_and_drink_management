class AddPriceToProducts < ActiveRecord::Migration[7.0]
  def change
    remove_column :products, :price, :decimal

    add_monetize :products, :price, currency: { present: false }
  end
end
