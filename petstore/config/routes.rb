Rails.application.routes.draw do
  get 'search', to: 'pets#search'

  resources :pets
  resources :stores

  root 'pets#index'
end
