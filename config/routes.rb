Rails.application.routes.draw do
  root 'stores#index'

  get 'search', to: 'pets#search'
  get 'sold', to: 'orders#sold'

  resources :pets
  resources :stores, path: 'store', only: [:index]
  resources :orders, path: 'store/order', only: [:index, :new, :create, :show, :destroy]
end
