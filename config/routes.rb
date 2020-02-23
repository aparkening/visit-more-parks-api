Rails.application.routes.draw do
  get '/' => 'application#index'
  post '/login' => 'sessions#login'
  post '/signup' => 'users#create'
  delete '/logout' => 'sessions#destroy'
  get '/auth-check' => 'sessions#auth_check'
  get '/auth/:provider/callback' => 'sessions#google_callback'
  get '/auth/google/redirect' => 'sessions#google_redirect'

  namespace :api do
    namespace :v1 do

      # Parks
      resources :parks, only: [:index]

      # Users
      resources :users, only: [:destroy]
      post '/signup' => 'users#create'

      # Events
      resources :events, only: [:index, :show, :create, :update, :destroy]
 
      # # Sessions
      # get '/login' => 'sessions#login'
      # get '/login' => 'sessions#new'
      # get '/logout' => 'sessions#destroy'
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
