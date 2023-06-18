Rails.application.routes.draw do
  root 'stores#index'

  resources :pets do
    get 'search', to: 'pets#search'
  end

  resources :stores, path: 'store', only: [:index]
  resources :orders, path: 'store/order', only: [:index, :new, :create, :show, :destroy]
end
