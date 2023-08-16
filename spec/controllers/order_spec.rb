require 'rails_helper'

RSpec.describe OrdersController do
  describe 'limiter' do

    before(:each) do
      sleep(1)
    end

    context ':new' do
      let(:fake_pet) { double('fake_pet', id: 1) }

      before do
        allow(Pet).to receive(:find).and_return(fake_pet)
        allow(fake_pet).to receive(:sold).and_return false
      end

      it 'allows GET requests <= 4 per second' do
        4.times { get :new, params: { id: fake_pet.id } }
        expect(response).to have_http_status(200)
      end

      it 'blocks GET requests > 5 per second' do
        expect { 6.times { get :new, params: { id: fake_pet.id } } }.to output('Limit reached!').to_stdout
      end
    end

    context ':show' do
      let(:fake_pet) { double('fake_pet', id: 1) }
      let(:fake_order) { double('fake_order', id: 1) }

      before do
        allow(Pet).to receive(:find).and_return(fake_pet)
        allow(Rails.cache).to receive(:fetch).with("order#{fake_order.id}", expires_in: 30.minutes).and_return(fake_order)
      end

      it 'allows GET requests <= 4 per second' do
        4.times { get :show, params: { id: fake_order.id } }
        expect(response).to have_http_status(200)
      end

      it 'blocks GET requests > 5 per second' do
        expect { 6.times { get :show, params: { id: fake_order.id } } }.to output('Limit reached!').to_stdout
      end
    end
  end
end
