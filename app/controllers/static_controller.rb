class StaticController < ApplicationController

  def index
    facebook_account = UserAccount.where(provider:"facebook", user: current_user).first
    if current_user
      if current_user && current_user.provider == "facebook"
        url = HTTParty.get("https://graph.facebook.com/#{current_user.uid}/music?access_token=#{current_user.oauth_token}&method=GET&metadata=true&limit=1000&format=json")
        @music = JSON.parse(url.body)
        @music["data"].each do |band|
          # call method from application controller to pull artists from a provider  
          get_artists(band["name"], "facebook")
        end
      elsif current_user && facebook_account
        url = HTTParty.get("https://graph.facebook.com/#{facebook_account.uid}/music?access_token=#{facebook_account.oauth_token}&method=GET&metadata=true&limit=1000&format=json")
        @music = JSON.parse(url.body)
        @music["data"].each do |band|
          # call method from application controller to pull artists from a provider  
          get_artists(band["name"], "facebook")
        end
      end
    else
      redirect_to welcome_path
    end
  end


  
end
