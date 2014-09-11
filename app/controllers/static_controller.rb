class StaticController < ApplicationController

  def index
    # if current_user
    # # Display for current_user
    # else
    #   redirect_to welcome_path
    # end


  end

  def spotify
    # Find the access token
    res = HTTParty.post('https://accounts.spotify.com/authorize',
      { body: { client_id: ENV['SPOTIFY_CLIENT_ID'],
        client_secret: ENV['SPOTIFY_CLIENT_SECRET'],
        code: params[:code] },
        headers: { 'Accept' => 'application/json' }
      })
    puts 'Spotify'
    puts res.parsed_response.inspect
    redirect_to repos_path(acc_token: res.parsed_response['access_token'])
  end

end
