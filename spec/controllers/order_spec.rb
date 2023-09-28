# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrdersController do
  subject(:fake_order) { Order.create(user_email: 'test@email.com', pet_id: 1) }
  let(:fake_pet) { Pet.create(name: 'test', species: 'test', age: 11, price: 1.99) }

  context 'Controller Actions' do
    before do
      allow(Pet).to receive(:find).and_return(fake_pet)
    end

    context 'when sending GET request to :new' do
      context 'when pet is available for order' do
        it 'returns status code 200' do
          get :new
          expect(response).to have_http_status(200)
        end
      end

      context 'when pet is unavailable for order' do
        it 'returns status code 302' do
          fake_pet.sold = true
          get :new
          expect(response).to have_http_status(302)
        end
      end
    end

    context 'when sending POST request to :create' do
      context 'when valid data is submitted' do
        it 'redirects with status code 302' do
          post :create, params: { order: { user_email: 'test@email.com', pet_id: fake_pet.id } }
          expect(response).to have_http_status(302)
        end
      end

      context 'when invalid data is submitted' do
        it 'returns status unprocessable entity' do
          post :create, params: { order: { user_email: 'test.com', pet_id: fake_pet.id } }
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

    context 'when sending DELETE request to :destroy' do
      it 'returns status code 302' do
        fake_order.id = 1
        fake_order.pet = fake_pet
        allow(Order).to receive(:find).and_return(fake_order)
        delete :destroy, params: { id: fake_order.id }
        expect(response).to have_http_status(302)
      end
    end
  end

  context 'Rate Limiting' do
    before(:each) do
      sleep(1)
    end

    before do
      allow(Pet).to receive(:find).and_return(fake_pet)
    end

    context 'when sending GET request to :new' do
      it 'allows requests <= 5 per second' do
        5.times { get :new }
        expect(response).to have_http_status(200)
      end

      it 'blocks requests > 5 per second' do
        expect { 6.times { get :new } }.to output('Limit reached!').to_stdout
      end
    end

    context 'when sending GET request to :sold' do
      before do
        fake_pet.sold = true
      end

      it 'allows requests <= 5 per second' do
        5.times { get :sold }
        expect(response).to have_http_status(200)
      end

      it 'blocks requests > 5 per second' do
        expect { 6.times { get :sold } }.to output('Limit reached!').to_stdout
      end
    end

    context 'when sending GET request to :show' do
      before do
        allow(Order).to receive(:find).and_return(fake_order)
      end

      it 'allows requests <= 5 per second' do
        get :show, params: { id: 1 }
        expect(response).to have_http_status(200)
      end

      it 'blocks requests > 5 per second' do
        expect { 6.times { get :show, params: { id: 1 } } }.to output('Limit reached!').to_stdout
      end
    end
  end
end
