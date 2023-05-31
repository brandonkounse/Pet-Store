module PetsHelper
  def pet_image_path(pet)
    pet_img = "#{pet.species.downcase}.jpg"
    pet_img = 'nil' unless File.exist?(Rails.root.join('app', 'assets', 'images', pet_img))
    pet_img
  end
end
