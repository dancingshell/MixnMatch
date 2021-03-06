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

        facebook_artists
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
          facebook_artists
        end
      # Spotify
      else
        spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
        #raise spotify_user.inspect
        # Access private data
        spotify_account = UserAccount.where(user: current_user, provider: 'spotify').first
        spotify_account = UserAccount.create!(email: spotify_user.email,
          user: current_user, provider: 'spotify', oauth_token: spotify_user.credentials.token, refresh_token: spotify_user.credentials.refresh_token, oauth_expires_at: spotify_user.credentials.expires_at) unless spotify_account
        
        spotify_artists
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


  def facebook_artists
    if current_user
             # finds user account of facebook if user logs in through mixnmatch
      facebook_account = UserAccount.where(provider:"facebook", user: current_user).first if current_user.provider == "mixnmatch"
      if current_user && current_user.provider == "facebook"
        # get facebook music through facebook login
        url = HTTParty.get("https://graph.facebook.com/#{current_user.uid}/music?access_token=#{current_user.oauth_token}&method=GET&metadata=true&limit=1000&format=json")
        @music = JSON.parse(url.body)
        
        @music["data"].each do |band|
          # call method from application controller to pull artists from a provider  
          get_artists(band["name"], "facebook")
        end
      elsif current_user && facebook_account
        # get facebook music through user_account
        url = HTTParty.get("https://graph.facebook.com/#{facebook_account.uid}/music?access_token=#{facebook_account.oauth_token}&method=GET&metadata=true&limit=1000&format=json")
        @music = JSON.parse(url.body)
        @music["data"].each do |band|
          # call method from application controller to pull artists from a provider  
          get_artists(band["name"], "facebook")
        end
      end

      if current_user.profiles.first.nil?
        redirect_to new_profile_path
      elsif current_user.profiles.first && current_user.provider == "facebook"
        redirect_to root_path
      else
        redirect_to accounts_path
      end
    end
  end

  def spotify_artists
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    #spotify_account = UserAccount.where(user: current_user, provider: 'spotify').first
    spotify_tracks = spotify_user.saved_tracks(limit: 50, offset: 0)
    spotify_tracks.each do |artist_track|
      artist_track.artists.each do |band|
        # Call method from application controller to pull artists from a provider  
        get_artists(band.name, 'spotify')  
      end 
    end
    redirect_to accounts_path
  end


  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end

