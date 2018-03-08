Rails.application.routes.draw do
  post '/callback' => 'webhook#callback'
  resources :tops, only: [:index]
end
