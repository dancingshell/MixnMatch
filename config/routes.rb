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
  get '/auth/:facebook/callback', to: 'sessions#create'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # Spotify OAuth
  get '/spotify' => 'static#spotify'

  # Session
  resource :session, only: [:new, :create, :destroy]

  # Root
  root 'static#index'

end
