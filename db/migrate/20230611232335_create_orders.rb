class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :order_number
      t.date :order_date
      t.decimal :total_cost
      t.text :order_details
      t.string :user_email

      t.timestamps
    end
  end
end
