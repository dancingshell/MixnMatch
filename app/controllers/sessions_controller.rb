class SessionsController < ApplicationController
  def create
    if env["omniauth.auth"].provider == 'facebook'
      user = User.from_omniauth(env["omniauth.auth"])
      session[:user_id] = user.id
      redirect_to root_url

    else
      spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
  
      #raise @spotify_user.inspect
      # Access private data
      spotify_account = UserAccount.where(user: current_user, provider: "spotify").first
      spotify_account = UserAccount.create!(email: spotify_user.email, user: current_user, provider: "spotify", oauth_token: spotify_user.credentials.token, refresh_token: spotify_user.credentials.refresh_token, oauth_expires_at: spotify_user.credentials.expires_at) unless spotify_account

      spotify_tracks = spotify_user.saved_tracks(limit: 50, offset: 0)
      spotify_tracks.each do |artist_track|
        artist_track.artists.each do |band|
        # call method from application controller to pull artists from a provider  
        get_artists(band.name, "spotify")

        end 
      end
      artist_events = current_user.artists.take(5)
      artist_events.each do |a|
        get_events(a)
      end
      redirect_to root_url

    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end

