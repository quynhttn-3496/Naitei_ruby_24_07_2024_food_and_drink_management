class AddTotalAmountCentToOrderItems < ActiveRecord::Migration[7.0]
  def change
    remove_column :order_items, :total_amount, :decimal

    add_monetize :order_items, :total_amount
  end
end
