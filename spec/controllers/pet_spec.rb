# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PetsController do
  let(:user) { User.create(email: 'user@example.com', password: 'password123') }

  before do
    sign_in user
  end

  context 'Controller Actions' do
    context 'when sending GET request to :index' do
      it 'returns status code 200' do
        get :index
        expect(response).to have_http_status(200)
      end
    end

    context 'when sending GET request to :new' do
      it 'returns status code 200' do
        get :new
        expect(response).to have_http_status(200)
      end
    end

    context 'when sending POST request to :create' do
      context 'when submitting valid data' do
        it 'successfully redirects with code 302' do
          post :create, params: { pet: { name: 'test', species: 'tester', age: 1, price: 4.99 } }
          expect(response).to have_http_status(302)
        end
      end

      context 'when submitting invalid data' do
        it 'returns status code 422' do
          post :create, params: { pet: { name: 'test' } }
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'when sending GET request to :show' do
      let(:fake_pet) { double('fake_pet', id: 17) }

      it 'returns status code 200' do
        allow(Rails.cache).to receive(:fetch).with("pet#{fake_pet.id}", expires_in: 30.minutes).and_return(fake_pet)
        get :show, params: { id: fake_pet.id }
        expect(response).to have_http_status(200)
      end
    end

    context 'when sending GET request to :edit' do
      let(:fake_pet) { double('fake_pet', id: 19) }

      it 'returns status code 200' do
        allow(Rails.cache).to receive(:fetch).with("pet#{fake_pet.id}", expires_in: 30.minutes).and_return(fake_pet)
        get :edit, params: { id: fake_pet.id }
        expect(response).to have_http_status(200)
      end
    end

    context 'when sending PUT request to :update' do
      let(:fake_pet) { Pet.create(id: 1000, name: 'bugs', species: 'bugsby', age: 9, price: 11.99) }

      context 'when submitting valid data' do
        it 'successfully redirects with code 302' do
          put :update, params: { id: fake_pet.id, pet: { name: 'test', species: 'tester', age: 1, price: 4.99 } }
          expect(response).to have_http_status(302)
        end
      end

      context 'when submitting invalid data' do
        it 'returns status code 422' do
          put :update, params: { id: fake_pet.id, pet: { name: '' } }
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'when sending GET request to :search' do
      context 'when no results are found' do
        let(:fake_search) { '999' }

        it 'returns no results with status code 200' do
          get :search, params: { search: fake_search }
          expect(response).to have_http_status(200)
        end
      end

      context 'when one result is found' do
        let(:fake_pet) { double('fake_pet', id: 1) }
        let(:fake_search) { '1' }

        it 'returns one result and redirects with status code 302' do
          allow(Pet).to receive(:where).with('id = ?', fake_pet.id).and_return(fake_pet)
          allow(fake_pet).to receive(:empty?).and_return false
          allow(fake_pet).to receive(:count).and_return(1)
          allow(fake_pet).to receive(:first).and_return(fake_pet.id)
          get :search, params: { search: fake_search }
          expect(response).to have_http_status(302)
        end
      end

      context 'when many results are found' do
        let(:fake_search) { 'Bin' }
        let(:pet_one) { Pet.create(name: 'Binder', species: 'dog', age: 11, price: 12.99) }
        let(:pet_two) { Pet.create(name: 'Binzel', species: 'dog', age: 11, price: 12.99) }

        it 'returns multiple results with status code 200' do
          get :search, params: { search: fake_search }
          expect(response).to have_http_status(200)
        end
      end
    end

    context 'when sending DELETE request to :destroy' do
      let(:fake_pet) { Pet.create(name: 'goodbye_world', species: '?', age: 1, price: 1.99) }

      it 'returns status code 302 on deletion' do
        delete :destroy, params: { id: fake_pet.id }
        expect(response).to have_http_status(302)
      end
    end
  end

  context 'Rate Limiting' do
    before(:each) do
      sleep(1)
    end

    context 'when sending GET request to :index' do
      it 'allows requests <= 5 per second' do
        5.times { get :index }
        expect(response).to have_http_status(200)
      end

      it 'blocks requests > 5 per second' do
        expect { 6.times { get :index } }.to output('Limit reached!').to_stdout
      end
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

    context 'when sending GET request to :show' do
      let(:fake_pet) { double('fake_pet', id: 1) }

      it 'allows requests <= 5 per second' do
        allow(Pet).to receive(:find).and_return(fake_pet.id)
        5.times { get :show, params: { id: fake_pet.id } }
        expect(response).to have_http_status(200)
      end

      it 'blocks requests > 5 per second' do
        allow(Pet).to receive(:find).and_return(fake_pet.id)
        expect { 6.times { get :show, params: { id: fake_pet.id } } }.to output('Limit reached!').to_stdout
      end
    end

    context 'when sending GET request to :edit' do
      let(:fake_pet) { double('fake_pet', id: 1) }

      it 'allows requests <= 5 per second' do
        allow(Pet).to receive(:find).and_return(fake_pet.id)
        5.times { get :edit, params: { id: fake_pet.id } }
        expect(response).to have_http_status(200)
      end

      it 'blocks requests > 5 per second' do
        allow(Pet).to receive(:find).and_return(fake_pet.id)
        expect { 6.times { get :edit, params: { id: fake_pet.id } } }.to output('Limit reached!').to_stdout
      end
    end

    context 'when sending GET request to :search' do
      let(:fake_search) { 'sa' }

      it 'allows requests <= 5 per second' do
        allow(Pet).to receive(:where).and_return(search: fake_search)
        5.times { get :search, params: { search: fake_search } }
        expect(response).to have_http_status(302)
      end

      it 'blocks requests > 5 per second' do
        allow(Pet).to receive(:where).and_return(search: fake_search)
        expect { 6.times { get :search, params: { search: fake_search } } }.to output('Limit reached!').to_stdout
      end
    end
  end
end
