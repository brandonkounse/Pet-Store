# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StoresController do
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

    context ':inventory' do
      it 'allows get requests <= 4 per second' do
        4.times { get :inventory }
        expect(response).to have_http_status(200)
      end

      it 'blocks get requests > 5 per second' do
        expect { 6.times { get :inventory } }.to output('Limit reached!').to_stdout
      end
    end
  end
end
