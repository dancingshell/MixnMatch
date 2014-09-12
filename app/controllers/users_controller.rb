class UsersController < ApplicationController
  def new
  end

  def index
  end

  def show
  end

  def edit
  end

  def spotify

    @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    # Access private data
    spotify_user.email   #=> "example@email.com"

    # Create playlist in user's Spotify account
    # Add tracks to a playlist in user's Spotify account
    @spotify2 = spotify_user.saved_tracks(limit: 50, offset: 0)
    @spotify = spotify_user.saved_tracks #=> 20
  end
end
