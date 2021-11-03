Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => "/sidekiq"

  devise_for :users, path: 'auth', controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :users, except: [:new, :create] do
    # resources :reservations
  end

  resources :organizations do
    resources :comments, only: [:new, :create, :destroy]
  end

  resources :comments, only: [:new, :create, :destroy] do
    resources :comments, only: [:new, :create, :destroy]
  end

  resources :services, except: :show
  resources :organization_services, only: [:new, :create, :destroy] do
    resources :time_slots
    resources :workers, except: [:index, :show]
  end

  resources :reservations

  get '/search', to: 'search#index'

  get 'home/index'
  root to: 'home#index'
end
