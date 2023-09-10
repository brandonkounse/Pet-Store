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
    respond_to do |format|
      if @pet.update(pet_params)
        format.html { redirect_to @pet }
        format.json { render json: { name: @pet.name, species: @pet.species, age: @pet.age, price: @pet.price } }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @pet.errors.full_messages } }
      end
    end
  end

  def search
    @search_query = params[:search]
    respond_to do |format|
      begin
        @pet = Pet.where('id = ?', Integer(@search_query))
      rescue ArgumentError
        @pet = Pet.where('name ILIKE ?', "%#{@search_query}%")
      end

      if @pet.empty?
        format.html { flash.now[:notice] = 'No pets found' }
        format.json { render json: { errors: 'No pets found' } }
      elsif @pet.count == 1
        format.html { redirect_to pet_path(@pet.first) }
        format.json { render json: @pet.first }
      end
      format.html
      format.json { render json: @pet }
    end
  end

  def destroy
    @pet = Pet.find(params[:id])
    @pet.destroy
    respond_to do |format|
      format.html { redirect_to pets_path, notice: "#{@pet.name} deleted successfully." }
      format.json { render json: "#{@pet.name} deleted successfully." }
    end
  end

  private

  def pet_params
    params.require(:pet).permit(:name, :species, :age, :price)
  end
end
