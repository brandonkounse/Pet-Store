class StoresController < ApplicationController
  def index
    @pet = Pet.all
  end

  def show
    @pet = Pet.find(params[:id])
  end
end
