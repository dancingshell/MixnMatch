class UserAccountsController < ApplicationController

  def create
    @user_account = current_user.user_accounts.new(account_params) 
    if @user_account.save

      if @user_account.provider == 'rdio'
        client = RdioApi.new(consumer_key: ENV['RDIO_KEY'], consumer_secret: ENV['RDIO_SECRET'])
        @rdio = client.findUser(email: @user_account.email)
        # Insert rdio user does not exist statement
        @rdio_key = @rdio['key']
        @rdio_rotation = client.getHeavyRotation(user: @rdio_key)
        @rdio_rotation.each do |rdio|
          get_artists(rdio['artist'], 'rdio')
        end
      end

      if @user_account.provider == 'lastfm'
        url = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user=#{@user_account.username}&api_key=2d4eafcd13fe4bd7da79ea43ecd3dded&format=json")
        @lastfm = JSON.parse(url.body)
        @lastfm['topartists']['artist'].each do |lastfm|
          get_artists(lastfm['name'], 'lastfm')
        end
      end

      redirect_to root_path
    else
      # render
    end
  end

  private

  def account_params
    params.require(:user_account).permit(:provider, :email, :username)
  end

end
