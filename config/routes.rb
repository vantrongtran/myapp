Rails.application.routes.draw do
  root "static_pages#home"
  get "/help", to: "static_pages#help"
  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :categories, only: :index do
    resources :lessons
  end
  resources :relationships
  resources :words
  namespace :admin  do
    root "static_pages#home"
    resources :users
    resources :categories
    resources :words
  end
end
