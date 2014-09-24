class SessionsController < ApplicationController
  
  def create
    # OmniAuth
    if env['omniauth.auth']
      # Facebook
      if env['omniauth.auth'].provider == 'facebook' && !current_user
        # creates new user / logs in through facebook if user is not logged in
        # goes through User model
        user = User.from_omniauth(env['omniauth.auth'])
        session[:user_id] = user.id
        redirect_to root_url

        # Find events for artists on delay ( method in app controller )
        current_artists.each { |a| EventWorker.perform_async(a.id) }
        
        # Note 1: runs after user logs in with Facebook
        # Note 2: sidekiq only likes params that are serialized

      elsif env['omniauth.auth'].provider == 'facebook' && current_user
        # creates new user account for user if they are logged in via MixnMatch authentication
        # goes through UserAccount model
        facebook = UserAccount.from_omniauth(env['omniauth.auth'])
        facebook.user = current_user
        facebook.save!
        if facebook.save
          redirect_to accounts_path
        end
      else
      # Spotify
        spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
        # Access private data
        spotify_account = UserAccount.where(user: current_user, provider: 'spotify').first
        spotify_account = UserAccount.create!(email: spotify_user.email,
          user: current_user, provider: 'spotify', oauth_token: spotify_user.credentials.token, refresh_token: spotify_user.credentials.refresh_token, oauth_expires_at: spotify_user.credentials.expires_at) unless spotify_account
        spotify_tracks = spotify_user.saved_tracks(limit: 50, offset: 0)
        spotify_tracks.each do |artist_track|
          artist_track.artists.each do |band|
            # Call method from application controller to pull artists from a provider  
            get_artists(band.name, 'spotify')  
          end 
        end
        redirect_to accounts_path
      end
    else
      
      user = User.where(email: params[:user][:email], provider: "mixnmatch").first
      # Checks to see if the user exists, and then for a matching password
      if user && user.authenticate(params[:user][:password]) 
        # Creates a cookie for the user, holding the logged in user ID
        session[:user_id] = user.id.to_s
        redirect_to root_path

        # Find events for artists on delay ( method in app controller )

        current_artists.each { |a| EventWorker.perform_async(a.id) }

        # Note 1: runs after user logs in with MixnMatch
        # Note 2: sidekiq only likes params that are serialized

      else
        redirect_to :back
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end

