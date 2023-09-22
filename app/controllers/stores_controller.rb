# frozen_string_literal: true

class StoresController < ApplicationController
  extend Limiter::Mixin
  extend LimitHelper

  MAX_PETS_PER_PAGE = 25

  limit(:index, :inventory)

  def index
    @pet = Pet.order(:id).paginate(page: params[:page], per_page: MAX_PETS_PER_PAGE)

    respond_to do |format|
      format.html
      format.json do
        render json: {
          page: params.fetch(:page, 1),
          number_of_pages: (Pet.count.to_f / MAX_PETS_PER_PAGE).ceil,
          pets: @pet
        }
      end
    end
  end

  def inventory
    @pet = Pet.all

    render json: {
      "sold": Pet.where(sold: true).count,
      "available": Pet.where(sold: false).count
    }
  end
end
