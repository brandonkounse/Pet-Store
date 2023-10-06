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
    @order.pet = cached_pet_data
    session[:pet] = @order.pet.id
    pet_sold?
  end

  def create
    @order = Order.new(order_params)
    @order.pet = Pet.find_by_id(params[:order][:pet_id]) if params[:order][:pet_id]

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order }
        format.json { render json: @order }
      else
        format.html do
          render :new, status: :unprocessable_entity
        end
        format.json { render json: { errors: @order.errors.full_messages } }
      end
    end
  end

  def show
    respond_to do |format|
      if @order
        format.html
        format.json { render json: @order }
      else
        format.html { redirect_to stores_path, notice: 'Order not found' }
        format.json { render json: 'Record Not Found', status: :not_found }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @order
        @order.destroy
        format.html { redirect_to stores_path, notice: "Order for #{@order.pet.name} cancelled successfully!" }
        format.json { render json: "Order for #{@order.pet.name} successfully cancelled." }
      else
        format.json { render json: 'Record Not Found', status: :not_found }
      end
    end
  end

  def sold
    @pet = Pet.find(session[:pet])
  end

  private

  def order_params
    params.require(:order).permit(:user_email, :pet_id)
  end

  def set_order
    @order = cached_order_data
  end

  def pet_sold?
    if @order.pet.sold
      redirect_to :sold
    else
      render :new
    end
  end
end
