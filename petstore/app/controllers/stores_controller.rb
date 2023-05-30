class StoresController < ApplicationController
  def index
    @pet = Pet.all
  end
end
