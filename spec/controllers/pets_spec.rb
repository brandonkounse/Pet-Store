require 'rails_helper'

RSpec.describe PetsController, type: :controller do
  context 'index' do
    it 'assigns @pets to Pet.all' do
      pets = Pet.all
      get :index
      expect(pets).to eq(Pet.all)
    end

    it 'renders #index view' do
      pets = Pet.all
      get :index
      expect(response).to render_template(:index)
    end
  end
end
