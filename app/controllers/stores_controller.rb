class StoresController < ApplicationController
  extend Limiter::Mixin

  limit_method(:index, rate: 5, interval: 1) { print 'Limit reached!' }

  def index
    @pet = Pet.paginate(page: params[:page], per_page: 25)
  end

  def inventory
    @pet = Pet.all
  end
end
