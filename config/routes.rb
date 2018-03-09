Rails.application.routes.draw do
  root "tops#index"
  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks"
  }
  post '/callback' => 'webhook#callback'
  resources :tops, only: [:index]
  resources :users, only: [:index]
  resources :posts, only: [:new, :create]
  get 'user' => 'tops#show'
end
