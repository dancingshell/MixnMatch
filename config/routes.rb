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
  resources :matches, shallow: true do
    resources :messages
  end
  resources :events, shallow: true do
    resources :groups
  end

  get "/api/matches" => "matches#match_json"


  # Facebook/spotify callback for login
  
  match 'auth/:faceback/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]

  

  # Welcome / Sign Up
  get '/welcome', to: 'users#new'
  get '/privacy', to: 'static#privacy'

  # Session
  resource :session, only: [:new, :create, :destroy]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  # Root
  root 'static#index'

end
