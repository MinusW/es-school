Rails.application.routes.draw do
  # Authentication routes
  devise_for :users, skip: [ :registrations ]

  # Root path
  root "home#index"

  # Application resources
  resources :users, except: :destroy
  resources :teachers do
    member do
      get :calendar
    end
  end
  resources :addresses
  resources :rooms
  resources :class_types
  resources :themes
  resources :classrooms do
    member do
      get :calendar
      post :promote
    end
  end
  resources :students do
    member do
      get "generate_pdf"
    end
  end
  resources :courses
  resources :grades
  resources :quarters

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
