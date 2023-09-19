class AddPetToOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :order_details, :text
    add_reference :orders, :pet, null: false, foreign_key: true
  end
end
