class StoresController < ApplicationController
  def index
    @pet = Pet.all
  end

  def inventory
    @pet = Pet.all
  end
end
