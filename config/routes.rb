Rails.application.routes.draw do
  devise_for :users

  # Chat routes
  resources :chats, only: [ :index, :show, :create, :destroy ] do
    resources :messages, only: [ :create ]
  end

  # Health check for load balancers
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root "home#index"
end
