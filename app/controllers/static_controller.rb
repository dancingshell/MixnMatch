class StaticController < ApplicationController

  def index
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
    else
      redirect_to welcome_path
    end
  end

  def privacy
  end


  
end
