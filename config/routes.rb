Rails.application.routes.draw do
  # Root
  root 'application#index'
  
  get '/new' => 'sessions#new'
  # post '/login' => 'sessions#login'
  delete '/logout' => 'sessions#destroy'
  
  get '/auth-check' => 'sessions#auth_check'
  get '/auth/:provider/callback' => 'sessions#google_callback'
  get '/auth/google/redirect' => 'sessions#google_redirect'

  namespace :api do
    namespace :v1 do

      # Parks
      resources :parks, only: [:index]
      post '/parks/favorite' => 'parks#favorite'
      delete '/parks/unfavorite' => 'parkss#unfavorite'

      # Users
      resources :users, only: [:destroy]
      post '/signup' => 'users#create'

      # Events
      resources :events, only: [:index, :show, :create, :update, :destroy]
      # get 'test_create' => 'events#test_create'
      # get 'test_update' => 'events#test_update'
      # get 'test_destroy' => 'events#test_destroy'
    end
  end
end
