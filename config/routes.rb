Rails.application.routes.draw do
  root 'stores#index'

  get 'search', to: 'pets#search'
  get 'store/inventory', to: 'stores#inventory'
  get 'sold', to: 'orders#sold'

  resources :pets
  resources :stores, path: 'store', only: [:index]
  resources :orders, path: 'store/order', only: [:new, :create, :show, :destroy]
end
