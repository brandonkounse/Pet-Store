Rails.application.routes.draw do
  resources :pets
  resources :stores

  root 'main#index'
end
