Rails.application.routes.draw do
  resources :themes
  # Authentication routes
  devise_for :users

  # Root path
  root "home#index"

  # Application resources
  resources :users, except: :destroy
  resources :rooms
  resources :class_types
  resources :themes
  resources :classrooms
  resources :students
  resources :courses
  resources :grades

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
