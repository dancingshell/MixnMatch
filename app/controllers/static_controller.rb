class StaticController < ApplicationController

  def index
    if current_user && current_user.provider =="facebook"

      url = HTTParty.get("https://graph.facebook.com/#{current_user.uid}/music?access_token=#{current_user.oauth_token}&method=GET&metadata=true&limit=1000&format=json")

      @music = JSON.parse(url.body)
      
      @music["data"].each do |band|
        # create new artist in DB for each band returned from FB
        artist = Artist.where(name: band["name"]).first
        artist = Artist.create!(name: band["name"]) unless artist
        #make a join table match between that user and their bands
        UserArtist.create!(user: current_user, artist: artist) unless UserArtist.where(user: current_user, artist: artist).first
      end
    end
  end

  def show

  end
def spotify

    @spotify_user = RSpotify::UserAccount.create!(current_user, request.env['omniauth.auth'])
    # Access private data
    spotify_user.email   #=> "example@email.com"

    # Create playlist in user's Spotify account
    # Add tracks to a playlist in user's Spotify account
    @spotify_tracks = spotify_user.saved_tracks(limit: 50, offset: 0)
    @spotify_tracks.each do |x|
      x.artists.each do |y|
        current_user.artists.create!(name: y["name"])
      end 
    end
    
    #     <%= @spotify_user.inspect %>
    # <% @spotify2.each do |x|  %>
    # <% x.artists.each do |y|%>
    # <li><%= y.name %></li>
    # <% end %>
    # <% end %>
  end

end
