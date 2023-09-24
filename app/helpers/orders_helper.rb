# frozen_string_literal: true

module OrdersHelper
  def cached_order_data
    Rails.cache.fetch("order#{params[:id]}", expires_in: 30.minutes) do
      Order.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    nil
  end
end
