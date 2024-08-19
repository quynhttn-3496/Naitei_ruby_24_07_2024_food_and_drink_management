class ChangePriceCentsToDecimalInProducts < ActiveRecord::Migration[7.0]
  def change
    change_column :products, :price_cents, :decimal, precision: 15, scale: 2, default: 0, null: false
  end
end
