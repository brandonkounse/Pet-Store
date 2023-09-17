# frozen_string_literal: true

class CreateStores < ActiveRecord::Migration[7.0]
  def change
    create_table :stores do |t|
      t.references :pet, null: false, foreign_key: true
      t.datetime :order_date, null: false
      t.decimal :total_cost, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
