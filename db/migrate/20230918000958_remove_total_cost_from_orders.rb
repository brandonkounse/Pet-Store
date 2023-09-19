class RemoveTotalCostFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :total_cost
  end
end
