class StoresController < ApplicationController
  def index
    @pet = Pet.all
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new
  end

  def show
    @order = Order.find(params[:id])
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
  end
end
