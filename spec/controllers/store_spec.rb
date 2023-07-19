require 'rails_helper'

RSpec.describe StoresController do
  describe 'limiter' do
    it 'blocks > 5 requests per second' do
      expect { 6.times { get :index } }.to output('Limit reached!').to_stdout
    end
  end
end
