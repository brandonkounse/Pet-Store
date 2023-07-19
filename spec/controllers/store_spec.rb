require 'rails_helper'

RSpec.describe StoresController do
  describe 'limiter' do
    before(:each) do
      sleep(1)
    end

    it 'allows get requests <= 4 per second' do
      4.times { get :index }
      expect(response).to have_http_status(200)
    end

    it 'blocks get requests > 5 per second' do
      expect { 6.times { get :index } }.to output('Limit reached!').to_stdout
    end
  end
end
