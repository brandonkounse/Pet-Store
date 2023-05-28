class ChangePricePrecision < ActiveRecord::Migration[7.0]
  def change
    change_column :pets, :price, :decimal, precision: 5, scale: 2
  end
end
