MixnMatch::Application.routes.draw do

  # Sidekiq
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # Controllers / Views
  resources :users, except: :new
  resources :profiles
  resources :user_accounts, only: :create
  get '/accounts', to: 'user_accounts#accounts'
  resources :artists do
    resources :user_artists
  end
  resources :matches 
    resources :messages
  
  resources :events, shallow: true do
    resources :groups
  end

  get "/api/matches" => "matches#match_json"
  get "/api/events" => "events#event_json"

  get "/accounts/facebook", to: 'sessions#facebook_artists', as: :refresh_facebook
  # get "/auth/:spotify_refresh/callback", to: 'sessions#spotify_artists', as: :refresh_spotify

  # Facebook/spotify callback for login
  match 'auth/:google_oauth2/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/:facebook/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  
  

  # Welcome / Sign Up
  get '/welcome', to: 'users#new'
  get '/privacy', to: 'static#privacy'

  # Session
  resource :session, only: [:new, :create, :destroy]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  # Root
  root 'static#index'
  get '/home', to: 'static#welcome'

end
