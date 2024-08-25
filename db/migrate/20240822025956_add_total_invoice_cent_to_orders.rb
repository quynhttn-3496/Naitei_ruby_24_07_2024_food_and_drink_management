class AddTotalInvoiceCentToOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :total_invoice, :decimal

    add_monetize :orders, :total_invoice
  end
end
