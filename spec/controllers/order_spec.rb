# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrdersController do
  context 'Controller Actions' do
    subject(:fake_order) { Order.create(user_email: 'test@email.com', pet_id: 1) }
    let(:fake_pet) { Pet.create(name: 'test', species: 'test', age: 11, price: 1.99) }

    context 'when sending GET request to :new' do
      it 'returns status code 200' do
        allow(Pet).to receive(:find).and_return(fake_pet)
        get :new
        expect(response).to have_http_status(200)
      end
    end

    context 'when sending POST request to :create' do
      context 'when valid data is submitted' do
        it 'redirects with status code 302' do
          allow(Pet).to receive(:find).and_return(fake_pet)
          post :create, params: { order: { user_email: 'test@email.com', pet_id: 1 } }
          expect(response).to have_http_status(302)
        end
      end

      context 'when invalid data is submitted' do
        it 'returns status unprocessable entity' do
          allow(Pet).to receive(:find).and_return(fake_pet)
          post :create, params: { order: { user_email: 'test.com', pet_id: 1 } }
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'when sending GET request to :show' do
      it 'returns status code 200' do
        allow(Order).to receive(:find).and_return(fake_order)
        get :show, params: { id: 1 }
        expect(response).to have_http_status(200)
      end
    end
  end
end
