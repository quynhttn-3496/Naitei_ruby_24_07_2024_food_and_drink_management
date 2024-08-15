class AddColumnCardNumberToPaymentMethod < ActiveRecord::Migration[7.0]
  def change
    add_column :payment_methods, :card_number, :string
  end
end
