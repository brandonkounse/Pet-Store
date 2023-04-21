class RenamePetTypeToSpeciesInPets < ActiveRecord::Migration[7.0]
  def change
    rename_column :pets, :pet_type, :species
  end
end
