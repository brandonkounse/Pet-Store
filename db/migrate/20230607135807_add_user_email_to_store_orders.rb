class AddUserEmailToStoreOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :stores, :user_email, :string
  end
end
