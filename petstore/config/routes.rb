Rails.application.routes.draw do
  root 'stores#index'

  get 'search', to: 'pets#search'

  resources :pets
  resources :stores, path: 'store'

end
