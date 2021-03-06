class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string :email, null: false
      t.string :password_hash, null: false
      t.string :salt, null: false

      t.timestamps
    end
  end
end
