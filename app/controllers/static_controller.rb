class StaticController < ApplicationController

  def index
    if current_user
      # url = HTTParty.get("http://www.facebook.com/feeds/page.php?id=#{current_user.uid}&format=JSON")
      # url = HTTParty.get("https://graph.facebook.com/#{current_user.uid}")

      url = HTTParty.get("https://graph.facebook.com/#{current_user.uid}/music?access_token=#{current_user.oauth_token}&method=GET&metadata=true&format=json")
      @music = JSON.parse(url.body)
      spot_url =  HTTParty.get("https://api.spotify.com/v1/users/planetkaitlin/tracks?access_token=BQCnneB1RfY3TUU3VtMyjXUoATPTfroiFmSanI_HaNTj80279eeIDsNotpNTwFMmhcIqGpj68V2DGFWmyAuqZjoWAb9g3mG3ltFu2xsdW5OkQTAuioDJOtgGLeRNaPIjJnG")
      @spotify = JSON.parse(spot_url.body)
      # https://graph.facebook.com/me?access_token=theuseraccesstoken
    
    else
      @music = "you need to log in to see music"
    end
    # if current_user
    # # Display for current_user
    # else
    #   redirect_to welcome_path
    # end
    # url = HTTParty.get("http://api.openweathermap.org/data/2.5/forecast/daily?q=#{zipcode},USA&mode=json&units=imperial&cnt=1")
    # @weather = JSON.parse(url.body)


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
