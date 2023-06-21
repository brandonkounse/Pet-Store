class OrdersController < ApplicationController
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
    @order = Order.find(params[:id])
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
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
