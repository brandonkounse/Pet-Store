require 'rails_helper'

RSpec.describe PetsController do
  describe 'rate limiting' do
    before(:each) do
      sleep(1)
    end

    context 'when sending get requests to :index' do
      it 'allows requests <= 4 per second' do
        4.times { get :index }
        expect(response).to have_http_status(200)
      end

      it 'blocks requests > 5 per second' do
        expect { 6.times { get :index } }.to output('Limit reached!').to_stdout
      end
    end

    context 'when sending get requests to :new' do
      it 'allows requests <= 4 per second' do
        4.times { get :new }
        expect(response).to have_http_status(200)
      end

      it 'blocks requests > 5 per second' do
        expect { 6.times { get :new } }.to output('Limit reached!').to_stdout
      end
    end

    context 'when sending get requests to :show' do
      let(:fake_pet) { double('fake_pet', id: 1) }

      it 'allows requests <= 4 per second' do
        allow(Pet).to receive(:find).and_return(fake_pet.id)
        4.times { get :show, params: { id: fake_pet.id } }
        expect(response).to have_http_status(200)
      end

      it 'blocks requests > 6 per second' do
        allow(Pet).to receive(:find).and_return(fake_pet.id)
        expect { 6.times { get :show, params: { id: fake_pet.id } } }.to output('Limit reached!').to_stdout
      end
    end

    context 'when sending get requests to :edit' do
      let(:fake_pet) { double('fake_pet', id: 1) }

      it 'allows requests <= 4 per second' do
        allow(Pet).to receive(:find).and_return(fake_pet.id)
        4.times { get :edit, params: { id: fake_pet.id } }
        expect(response).to have_http_status(200)
      end

      it 'blocks requests > 6 per second' do
        allow(Pet).to receive(:find).and_return(fake_pet.id)
        expect { 6.times { get :edit, params: { id: fake_pet.id } } }.to output('Limit reached!').to_stdout
      end
    end

    context 'when sending get requests to :search' do
      let(:fake_search) { 'sa' }

      it 'allows requests <= 4 per second' do
         allow(Pet).to receive(:where).and_return(search: fake_search)
         4.times { get :search, params: { search: fake_search } }
         expect(response).to have_http_status(302)
      end

      it 'blocks requests > 6 per second' do
        allow(Pet).to receive(:where).and_return(search: fake_search)
        expect { 6.times { get :search, params: { search: fake_search } } }.to output('Limit reached!').to_stdout
      end
    end
  end
end
