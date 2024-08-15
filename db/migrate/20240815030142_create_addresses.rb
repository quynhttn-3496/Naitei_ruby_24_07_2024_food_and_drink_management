class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true, unique: true
      t.string :name
      t.string :address
      t.string :phone

      t.timestamps
    end
  end
end
