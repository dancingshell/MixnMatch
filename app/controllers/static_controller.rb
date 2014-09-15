class StaticController < ApplicationController

  def index
    if current_user && current_user.provider =="facebook"
      url = HTTParty.get("https://graph.facebook.com/#{current_user.uid}/music?access_token=#{current_user.oauth_token}&method=GET&metadata=true&limit=1000&format=json")
      @music = JSON.parse(url.body)
      
      @music["data"].each do |band|
        # call method from application controller to pull artists from a provider  
        get_artists(band["name"], "facebook")
      end
    elsif current_user && UserAccount.where(user: current_user, provider: "spotify").first
      # Add tracks to a playlist in user's Spotify account
      @spotify_tracks = spotify_user.saved_tracks(limit: 50, offset: 0)
      @spotify_tracks.each do |x|
        x.artists.each do |y|
          current_user.artists.create!(name: y["name"])
        end 
      end
    end
  end

  def rdio
    @rdio_email = UserAccount.new # (params.require[:user_account].permit(:email))
    @lastfm_username = UserAccount.new
    # if @rdio_email.save
    #   redirect_to :back
    # end
    # rdio_creds = UserAccount.update!(email: email, username: firstName + ' ' + lastName, provider: "rdio")
    # client = RdioApi.new(consumer_key: ENV['RDIO_KEY'], consumer_secret: ENV['RDIO_SECRET'])
    # @user = client.findUser(email: current_user.rdio_creds.email) # replace email with instance variable
    # @user_key = @user['key']
    # @user_rotation = client.getHeavyRotation(user: @user_key)
    # @user_ration.each do |rdio|
    #   get_artists(rdio['artist'], 'rdio')
    # end
  end

  def lastfm

    # url = HTTParty.get('http://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user=planetkaitlin&api_key=2d4ea...')
    # @lastfm = JSON.parse(url.body)
    # @lastfm['topartists']['artist'].each do |lastfm|
    #   get_artists(lastfm['name'], 'lastfm')
    # end
  end

  private


end
