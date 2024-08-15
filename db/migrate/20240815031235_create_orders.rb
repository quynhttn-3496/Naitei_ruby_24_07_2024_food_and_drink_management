class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status
      t.string :reason
      t.references :payment_method, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true
      t.decimal :total_invoice

      t.timestamps
    end
  end
end
