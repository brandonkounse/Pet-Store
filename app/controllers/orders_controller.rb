# frozen_string_literal: true

class OrdersController < ApplicationController
  extend Limiter::Mixin
  extend LimitHelper
  include OrdersHelper

  limit(:new, :show, :sold)

  def new
    session[:pet] = params[:id]
    @pet = Pet.find(session[:pet])
    @order = Order.new
    pet_sold?
  end

  def create
    @pet = Pet.find(session[:pet])
    @order = Order.new(order_params)
    if @order.save
      redirect_to @order
    else
      render :new, params: [session[:pet]], status: :unprocessable_entity
    end
  end

  def show
    @pet = Pet.find(session[:pet])
    @order = cached_order_data
  end

  def destroy
    @pet = Pet.find(session[:pet])
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to stores_path, notice: "Order for #{@pet.name} cancelled successfully!"
  end

  def sold
    @pet = Pet.find(session[:pet])
  end

  private

  def order_params
    params.require(:order).permit(:user_email, :total_cost, :order_details)
  end

  def pet_sold?
    if @pet.sold == true
      redirect_to :sold
    else
      render :new
    end
  end
end
