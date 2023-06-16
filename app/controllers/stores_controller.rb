class StoresController < ApplicationController
  def index
    @pet = Pet.all
  end

  def new
    @pet = Pet.find(params[:id])
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to stores_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
  end

  private

  def order_params
    params.require(:order).permit(:user_email, :total_cost, :order_details)
  end
end
