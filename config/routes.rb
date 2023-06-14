Rails.application.routes.draw do
  root 'stores#index'

  get 'search', to: 'pets#search'
  get '/store/order', to: 'stores#new'

  resources :pets
  resources :stores, path: 'store'
end
