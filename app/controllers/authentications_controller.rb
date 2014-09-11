class AuthenticationsController < ApplicationController
  require "koala"

  def index
    @authentications = current_user.authentications if current_user
  end

  def create
    auth = Authentication.from_omniauth(current_user, env["omniauth.auth"])
    flash[:notice] = "Authentication successful."
    redirect_to authentications_url
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end

  def start
    @oauth= Koala::Facebook::OAuth.new(APP_ID, APP_SECRET,REDIRECT_URI)
    redirect_to @oauth.url_for_oauth_code(:permissions=>"my permissions")
  end

  def callback
    session[:access_token] = @oauth.get_access_token(params[:code])
    redirect_to(:action=>"my action")
  end

end