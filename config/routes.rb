MixnMatch::Application.routes.draw do
  # require 'sidekiq/web'
  # mount Sidekiq::Web => '/sidekiq'
  # Controllers / Views
  resources :users, except: :new
  resources :profiles
  resources :user_accounts, only: :create
  get '/accounts', to: 'user_accounts#accounts'
  resources :artists do
    resources :user_artists
  end
  delete 'artists/:id', to: 'artists#remove_user_artist', as: "remove_user_artist"
  resources :matches, shallow: true do
    resources :messages
  end
  resources :events, shallow: true do
    resources :groups
  end

  get "/api/matches" => "matches#match_json"

  # Facebook/spotify callback for login
  resources :authentications
  match 'auth/:facebook/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  
  match 'auth/:facebook/callback', to: 'authentications#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]

  # Welcome / Sign Up
  get '/welcome', to: 'users#new'

  # Session
  resource :session, only: [:new, :create, :destroy]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  # Root
  root 'static#index'

end
