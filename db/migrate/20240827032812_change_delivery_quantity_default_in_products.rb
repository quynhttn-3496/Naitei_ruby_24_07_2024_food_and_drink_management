class ChangeDeliveryQuantityDefaultInProducts < ActiveRecord::Migration[7.0]
  def change
    change_column_default :products, :delivery_quantity, 0
  end
end
