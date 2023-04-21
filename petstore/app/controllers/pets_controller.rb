class PetsController < ApplicationController
  def index
    @pet = Pet.all
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

  def show
    @pet = Pet.find(params[:id])

    render 'show'
  end

  def update
    @pet = Pet.find(params[:id])
  end

  private

  def pet_params
    params.require(:pet).permit(:name, :species, :age)
  end
end
