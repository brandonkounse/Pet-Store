# frozen_string_literal: true

class OrdersController < ApplicationController
  extend Limiter::Mixin
  extend LimitHelper

  include PetsHelper
  include OrdersHelper

  before_action :set_order, only: %i[show destroy]
  limit(:new, :show, :sold)

  def new
    @order = Order.new
    @pet = cached_pet_data
    session[:pet] = @pet.id
    pet_sold?
  end

  def create
    @order = Order.new(order_params)
    @order.pet = Pet.find(params[:order][:pet_id])
    if @order.save
      redirect_to @order
    else
      @pet = Pet.find(params[:pet_id])
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @pet = @order.pet
  end

  def destroy
    @pet = @order.pet
    @order.destroy
    redirect_to stores_path, notice: "Order for #{@pet.name} cancelled successfully!"
  end

  def sold
    @pet = Pet.find(session[:pet_id])
  end

  private

  def order_params
    params.require(:order).permit(:user_email, :pet_id)
  end

  def set_order
    @order = cached_order_data
  end

  def pet_sold?
    if @pet.sold
      redirect_to :sold
    else
      render :new
    end
  end
end
