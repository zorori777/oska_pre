Rails.application.routes.draw do
  root "tops#index"
  post '/callback' => 'webhook#callback'
  resources :tops, only: [:index]
  resources :posts, only: [:new, :create]
end
