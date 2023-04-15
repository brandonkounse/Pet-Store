Rails.application.routes.draw do
  root 'pet_store#index'

  resources :pet
  resources :store
end
