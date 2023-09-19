# frozen_string_literal: true

class StoresController < ApplicationController
  extend Limiter::Mixin
  extend LimitHelper

  limit(:index, :inventory)

  def index
    @pet = Pet.order(:id).paginate(page: params[:page], per_page: 25)
  end

  def inventory
    @pet = Pet.all
  end
end
