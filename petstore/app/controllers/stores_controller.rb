class StoresController < ApplicationController
  def index
    @pet = Pet.all
  end

  def order
    @pet = Rails.cache.fetch("pet#{params[:id]}", expires_in: 30.minutes) do
      Pet.find(params[:id])
    end

    render :order
  end
end
