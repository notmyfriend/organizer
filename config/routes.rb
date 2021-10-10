Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => "/sidekiq"

  devise_for :users, path: 'auth', controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :users, except: [:new, :create] do
    # resources :reservations
  end

  resources :organizations
  resources :services, except: :show
  resources :organization_services, only: [:new, :create, :destroy] do
    resources :time_slots
  end

  resources :reservations

  get 'home/index'
  root to: "home#index"
end
