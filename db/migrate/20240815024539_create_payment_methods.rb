class CreatePaymentMethods < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_methods do |t|
      t.integer :payment_method

      t.timestamps
    end
  end
end
