# frozen_string_literal: true

class ChangeOrderNumberToConfirmationNumber < ActiveRecord::Migration[7.0]
  def change
    rename_column :orders, :order_number, :order_confirmation_number
  end
end
