Rails.application.routes.draw do
  get 'store/index'
  get 'pets/index'
  root 'main#index'
end
