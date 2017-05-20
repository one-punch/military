class AddUserCustomerIndex < ActiveRecord::Migration[5.0]
  def change
    add_index(:users, :username, unique: true)
    add_index(:customers, :email, unique: true)
  end
end
