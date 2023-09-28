# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'stores#index'

  get 'search', to: 'pets#search'
  get 'store/inventory', to: 'stores#inventory'
  get 'sold', to: 'orders#sold'

  resources :pets
  resources :stores, path: 'store', only: [:index]
  resources :orders, path: 'store/order', only: %i[new create show destroy]
end
