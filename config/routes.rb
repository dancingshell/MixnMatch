MixnMatch::Application.routes.draw do

  # Controllers / Views
  resources :users
  resource :profile
  resources :user_accounts, only: :create
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

  # Facebook callback for login
  resources :authentications
  match 'auth/:facebook/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  match 'auth/:facebook/callback', to: 'authentications#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # Spotify OAuth
  match '/auth/:spotify/callback', to: 'static#spotify', via: [:get, :post]

  get '/rdio', to: 'static#rdio'

  get '/static', to: 'static#lastfm'
  # Session
  resource :session, only: [:new, :create, :destroy]

  # Root
  root 'static#index'

end
