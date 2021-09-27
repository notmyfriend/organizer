Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :users, except: [:new, :create]
  resources :organizations

  get 'home/index'
  root to: "home#index"
end
