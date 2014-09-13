class SessionsController < ApplicationController
  def create
    if :facebook
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_url


    else
      @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
      # Access private data
      spotify_account = UserAccount.create!(email: @spotify_user.email, user: current_user)
      @spotify_user.email
      @spotify_user.destroy  #=> "example@email.com"
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end


  