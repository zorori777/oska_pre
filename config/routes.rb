Rails.application.routes.draw do
  devise_for :users
  root "tops#index"
  post '/callback' => 'webhook#callback'
  resources :tops, only: [:index]
  resources :users, only: [:index]
  resources :posts, only: [:new, :create]
end
