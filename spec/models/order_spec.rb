# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :order do
  let(:pet) { Pet.create(age: 1, name: 'test', species: 'tester', price: 100, id: 1) }

  before do
    allow(Pet).to receive(:find).and_return(pet)
  end

  context :email do
    it 'validates the presence of user email' do
      order = Order.new
      expect(order).to_not be_valid
      expect(order.errors[:user_email]).to include("can't be blank")
    end

    it 'invalidates incorrect email address syntax' do
      order = Order.create(user_email: 'test123', pet_id: 1)
      expect(order).to_not be_valid
      expect(order.errors[:user_email]).to include('is invalid')
    end

    it 'validates correct email address syntax' do
      order = Order.new(user_email: 'test@email.com', pet_id: 1)
      expect(order).to be_valid
    end
  end

  context :callbacks do
    it 'generates order number before_create' do
      order = Order.new(user_email: 'test@email.com', pet_id: 1)
      expect(order).to receive(:generate_order_number)
      order.save
    end

    it 'generates set order date before_create' do
      order = Order.new(user_email: 'test@email.com', pet_id: 1)
      expect(order).to receive(:set_order_date)
      order.save
    end

    it 'generates toggle sold after_commit' do
      order = Order.new(user_email: 'test@email.com', pet_id: 1)
      expect(order).to receive(:toggle_sold)
      order.save
    end
  end
end
