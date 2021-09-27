Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :users, except: [:new, :create]
  resources :organizations
  resources :services, except: :show
  resources :organization_services, only: [:new, :create, :destroy]

  get 'home/index'
  root to: "home#index"
end
