class EventsController < ApplicationController
  def new
  end

  def index
     url = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user=#{@user_account.username}&api_key=" + ENV['LASTFM_KEY'] + "&format=json")
        @lastfm = JSON.parse(url.body)
        http://ws.audioscrobbler.com/2.0/?method=event.getinfo&event=328799&api_key=+ ENV['LASTFM_KEY'] + &format=json
       
  end

  def show
  end

  def edit
  end
end


artist = Artist.where(name: artist_name).first
    artist = Artist.create!(name: artist_name) unless artist
    #make a join table match between that user and their bands
    UserArtist.create!(user: current_user, artist: artist, provider: provider) unless UserArtist.where(user: current_user, artist: artist).first