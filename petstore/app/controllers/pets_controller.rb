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

  def edit
    @pet = Pet.find(params[:id])
  end

  def update
    @pet = Pet.find(params[:id])
    if @pet.update(pet_params)
      redirect_to @pet
    else
      redirect_to edit_pet_url, alert: @pet.errors.full_messages.join(', ')
    end
  end

  def search
    @search_query = params[:search]
    begin
      @pet = Pet.where('id = ?', Integer(@search_query))
    rescue ArgumentError
      @pet = Pet.where('name ILIKE ?', "%#{@search_query}%")
    end

    if @pet.empty?
      flash.now[:notice] = 'No pets found'
    elsif @pet.count == 1
      redirect_to pet_path(@pet.first)
    end
  end

  def destroy
    @pet = Pet.find(params[:id])
    @pet.destroy
    redirect_to pets_path, notice: "#{@pet.name} deleted successfully."
  end

  private

  def pet_params
    params.require(:pet).permit(:name, :species, :age)
  end
end
