# frozen_string_literal: true

module PetsHelper
  def pet_image_path(pet)
    pet_img = "#{pet.species.downcase}.jpg"
    pet_img = 'nil' unless File.exist?(Rails.root.join('app', 'assets', 'images', pet_img))
    pet_img
  end

  def cached_pet_data
    Rails.cache.fetch("pet#{params[:id]}", expires_in: 30.minutes) do
      Pet.find(params[:id])
    end
  end
end
