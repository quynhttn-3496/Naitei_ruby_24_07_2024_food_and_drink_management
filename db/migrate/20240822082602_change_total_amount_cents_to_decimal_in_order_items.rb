class ChangeTotalAmountCentsToDecimalInOrderItems < ActiveRecord::Migration[7.0]
  def change
    change_column :order_items, :total_amount_cents, :decimal, precision: 15, scale: 2, default: 0, null: false
  end
end
