Rails.application.routes.draw do
  resources :pets
  resources :stores

  root 'pets#index'
end
