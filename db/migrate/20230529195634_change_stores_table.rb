# frozen_string_literal: true

class ChangeStoresTable < ActiveRecord::Migration[7.0]
  def change
    change_table :stores do |t|
      t.rename :pet_id, :order_number
      t.column :order_details, :bigint, array: true, default: []
    end
  end
end
