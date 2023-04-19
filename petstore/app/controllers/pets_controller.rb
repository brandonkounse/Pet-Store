class PetsController < ApplicationController
  def index
  end

  def new
    @pet = Pet.new
  end

  def create
    @pet = Pet.new(pet_params)
    if @pet.save
      redirect_to @pet
    else
      render 'new'
    end
  end

  private

  def pet_params
    params.require(:pet).permit(:name, :pet_type, :age)
  end
end
