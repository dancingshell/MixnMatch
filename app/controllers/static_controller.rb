class StaticController < ApplicationController

  def index
    if current_user && current_user.provider == "facebook"
      url = HTTParty.get("https://graph.facebook.com/#{current_user.uid}/music?access_token=#{current_user.oauth_token}&method=GET&metadata=true&limit=1000&format=json")
      @music = JSON.parse(url.body)
      @music["data"].each do |band|
        # call method from application controller to pull artists from a provider  
        get_artists(band["name"], "facebook")
      end
    end
  end
  
end
