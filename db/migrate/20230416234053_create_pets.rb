# frozen_string_literal: true

class CreatePets < ActiveRecord::Migration[7.0]
  def change
    create_table :pets do |t|
      t.string :name
      t.string :type
      t.integer :age

      t.timestamps
    end
  end
end
