Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :users, only: [:index, :show, :edit, :update, :destroy]

  get 'home/index'
  root to: "home#index"
end
