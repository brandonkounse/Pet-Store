require 'rails_helper'

RSpec.describe Order, type: :order do
  context :email do
    it 'validates the presence of user email' do
      order = Order.new
      expect(order.valid?).to be_falsey
      expect(order.errors[:user_email]).to include("can't be blank")
    end

    it 'validates correct email address syntax' do
      order = Order.new(user_email: 'test@email.com')
      expect(order.valid?).to be_truthy
    end

    it 'invalidates incorrect email address syntax' do
      order = Order.create(user_email: 'test123')
      expect(order.valid?).to be_falsey
      expect(order.errors[:user_email]).to include('is invalid')
    end
  end

  context :callbacks do
    it 'generates order number before_create' do
      pet = Pet.create(age: 1, name: 'test', species: 'tester', price: 100)
      order = Order.new(user_email: 'test@email.com', order_details: "{\"id\": #{pet.id}}")
      expect(order).to receive(:generate_order_number)
      order.save
    end

    it 'generates set order date before_create' do
      pet = Pet.create(age: 1, name: 'test', species: 'tester', price: 100)
      order = Order.new(user_email: 'test@email.com', order_details: "{\"id\": #{pet.id}}")
      expect(order).to receive(:set_order_date)
      order.save
    end

    it 'generates toggle sold after_commit' do
      pet = Pet.create(age: 1, name: 'test', species: 'tester', price: 100)
      order = Order.new(user_email: 'test@email.com', order_details: "{\"id\": #{pet.id}}")
      expect(order).to receive(:toggle_sold)
      order.save
    end
  end
end
