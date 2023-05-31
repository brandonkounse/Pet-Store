Rails.application.routes.draw do
  get 'search', to: 'pets#search'

  resources :pets
  resources :stores, path: 'store' do
    get 'order', on: :member
  end

  root 'stores#index'
end
