# frozen_string_literal: true

class RenameSpeciesColumnInPets < ActiveRecord::Migration[7.0]
  def change
    rename_column :pets, :species, :pet_type
  end
end
