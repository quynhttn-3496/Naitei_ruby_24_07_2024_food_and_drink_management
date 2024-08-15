class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, unique: true
      t.string :username
      t.string :password
      t.integer :role
      t.string :phone
      t.string :address
      t.string :password_digest

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
