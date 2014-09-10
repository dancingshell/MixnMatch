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

  # Spotify OAuth
  get '/spotify' => 'static#spotify'

  # Session
  resource :session, only: [:new, :create, :destroy]

  # Root
  root 'static#index'

end
