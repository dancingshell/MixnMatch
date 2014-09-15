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

  def spotify_get

    @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    # Access private data
    spotify_account = UserAccount.create!(email: @spotify_user.email, user: current_user)


    @spotify_user.email   #=> "example@email.com"
    redirect_to root_path
    
    # Create playlist in user's Spotify account
    # Add tracks to a playlist in user's Spotify account
    # @spotify_tracks = spotify_user.saved_tracks(limit: 50, offset: 0)
    # @spotify_tracks.each do |x|
    #   x.artists.each do |y|
    #     current_user.artists.create!(name: y["name"])
    #   end 
    # end

#     <%= @spotify_user.inspect %>
# <% @spotify2.each do |x|  %>
# <% x.artists.each do |y|%>
# <li><%= y.name %></li>
# <% end %>
# <% end %>
  end

  def create_spotify_account
    # spotify_account = UserAccount.create!(email: @spotify_user.email, user: current_user)


    # @spotify_user.email   #=> "example@email.com"
    # redirect_to root_path
  end

end
