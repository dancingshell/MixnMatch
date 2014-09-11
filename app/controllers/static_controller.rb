class StaticController < ApplicationController

  def index
    if current_user

      url = HTTParty.get("https://graph.facebook.com/#{current_user.uid}/music?access_token=#{current_user.oauth_token}&method=GET&metadata=true&limit=1000&format=json")

      @music = JSON.parse(url.body)
      @music["data"].each do |band|
        # create new artist in DB for each band returned from FB
        artist = Artist.where(name: band["name"]).first
        Artist.create!(name: band["name"]) unless artist
        # make a join table match between that user and their bands
        unless UserArtist.exists?(user: current_user, artist: artist)
          UserArtist.create!(user: current_user, artist: artist)
        end
      end

    end
  end

  def show

  end

  def spotify
    # Find the access token
    res = HTTParty.post('https://accounts.spotify.com/authorize',
      { body: { client_id: ENV['SP_CLIENT_ID'],
        client_secret: ENV['SP_CLIENT_SECRET'],
        code: params[:code] },
        headers: { 'Accept' => 'application/json' }
      })
    puts 'Spotify'
    puts res.parsed_response.inspect
    redirect_to repos_path(acc_token: res.parsed_response['access_token'])
  end

end
