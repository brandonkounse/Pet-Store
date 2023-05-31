Rails.application.routes.draw do
  get 'search', to: 'pets#search'

  resources :pets
  resources :stores, path: 'store'

  root 'pets#index'
end
