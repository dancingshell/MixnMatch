class SessionsController < ApplicationController
  def create
    if env["omniauth.auth"].provider == 'facebook'
      user = User.from_omniauth(env["omniauth.auth"])
      session[:user_id] = user.id
      redirect_to root_url

    else
      @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
      #raise @spotify_user.inspect
      # Access private data
      spotify_account = UserAccount.new(email: @spotify_user.email, user: current_user)

      # @spotify_user.email
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
