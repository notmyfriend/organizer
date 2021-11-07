Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => "/sidekiq"

  devise_for :users, path: 'auth', controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :users, except: [:new, :create] do
    get 'lock', to: 'users#lock'
    get 'unlock', to: 'users#unlock'
  end

  resources :organizations do
    resources :organization_services, only: [:new, :create, :destroy]
    resources :comments, only: [:new, :create, :destroy]
  end

  resources :comments do
    resources :comments, only: [:new, :create, :destroy]
  end

  resources :services, except: :show

  resources :organization_services do
    resources :time_slots
    resources :workers, except: [:index, :show]
  end

  resources :reservations

  get '/search', to: 'search#index'
  get 'search/autocomplete', to: 'search#autocomplete'

  get 'home/index'
  root to: 'home#index'
end
