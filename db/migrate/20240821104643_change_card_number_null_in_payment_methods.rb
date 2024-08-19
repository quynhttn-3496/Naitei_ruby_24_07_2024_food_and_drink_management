class ChangeCardNumberNullInPaymentMethods < ActiveRecord::Migration[7.0]
  def change
    change_column :payment_methods, :card_number, :string, null: true
  end
end
