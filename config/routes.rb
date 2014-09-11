MixnMatch::Application.routes.draw do

  
  # Controllers / Views
  resources :users
  resources :artists
  resources :matches, shallow: true do
    resources :messages
  end
  resources :events, shallow: true do
    resources :groups
  end

  #facebook callback for login
  resources :authentications
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]


  match 'auth/:provider/callback', to: 'authentications#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # Spotify OAuth
  get '/spotify' => 'static#spotify'

  # Session
  resource :session, only: [:new, :create, :destroy]

  # Root
  root 'static#index'

end
