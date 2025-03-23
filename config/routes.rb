Rails.application.routes.draw do
  resources :students
  resources :classrooms
  devise_for :users
  resources :users, except: :destroy
  root "home#index"
  resources :classrooms

  get "up" => "rails/health#show", as: :rails_health_check
end
