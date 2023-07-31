require 'rails_helper'

RSpec.describe PetsController do
  describe 'limiter' do
    before(:each) do
      sleep(1)
    end

    context ':index' do
      it 'allows get requests <= 4 per second' do
        4.times { get :index }
        expect(response).to have_http_status(200)
      end

      it 'blocks get requests > 5 per second' do
        expect { 6.times { get :index } }.to output('Limit reached!').to_stdout
      end
    end

    context ':new' do
      it 'allows get requests <= 4 per second' do
        4.times { get :new }
        expect(response).to have_http_status(200)
      end

      it 'blocks get requests > 5 per second' do
        expect { 6.times { get :new } }.to output('Limit reached!').to_stdout
      end
    end

    context ':show' do
      let(:fake_pet) { double('fake_pet', id: 1) }

      it 'allows get requests <= 4 per second' do
        allow(Pet).to receive(:find).and_return(fake_pet.id)
        4.times { get :show, params: { id: fake_pet.id } }
        expect(response).to have_http_status(200)
      end

      it 'blocks get requests > 6 per second' do
        allow(Pet).to receive(:find).and_return(fake_pet.id)
        expect { 6.times { get :show, params: { id: fake_pet.id } } }.to output('Limit reached!').to_stdout
      end
    end
  end
end
