class PetsController < ApplicationController
  extend Limiter::Mixin
  extend LimitHelper
  include PetsHelper

  limit(:index, :new, :show, :edit, :search)

  def index
    @pet = Pet.all

    respond_to do |format|
      format.html
      format.json { render json: @pet }
    end
  end

  def new
    @pet = Pet.new
  end

  def create
    @pet = Pet.new(pet_params)
    respond_to do |format|
      if @pet.save
        format.html { redirect_to @pet }
        format.json { render json: { name: @pet.name, species: @pet.species, age: @pet.age, price: @pet.price } }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @pet.errors.full_messages } }
      end
    end
  end

  def show
    @pet = cached_pet_data
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @pet }
    end
  end

  def edit
    @pet = Pet.find(params[:id])
  end

  def update
    @pet = Pet.find(params[:id])
    if @pet.update(pet_params)
      redirect_to @pet
    else
      render :edit, status: :unprocessable_entity
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
    params.require(:pet).permit(:name, :species, :age, :price)
  end
end
