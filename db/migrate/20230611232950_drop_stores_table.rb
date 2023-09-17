# frozen_string_literal: true

class DropStoresTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :stores
  end
end
