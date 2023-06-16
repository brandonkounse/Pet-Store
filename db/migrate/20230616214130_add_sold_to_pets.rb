class AddSoldToPets < ActiveRecord::Migration[7.0]
  def change
    add_column :pets, :sold, :boolean, default: false
  end
end
