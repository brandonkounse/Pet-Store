class StoresController < ApplicationController
  def index
    @pet = Pet.paginate(page: params[:page], per_page: 25)
  end

  def inventory
    @pet = Pet.all
  end
end
