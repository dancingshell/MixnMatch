class UserAccountsController < ApplicationController

  # POST '/user_accounts'
  def create
    @user_account = current_user.user_accounts.new(account_params) 
    if @user_account.save
      # Rdio
      if @user_account.provider == 'rdio'
        client = RdioApi.new(consumer_key: ENV['RDIO_KEY'], consumer_secret: ENV['RDIO_SECRET'])
        @rdio = client.findUser(email: @user_account.email)
        # If Rdio email does not exist
        if @rdio.nil?
          @user_account.destroy
          redirect_to :back
        # Else add Rdio artists to user artists
        else
          @rdio_key = @rdio['key']
          @rdio_rotation = client.getHeavyRotation(user: @rdio_key)
          # Get Rdio artists
          @rdio_rotation.each do |rdio|
            get_artists(rdio['artist'], 'rdio')
          end
          redirect_to :back
        end
      
      # Last.fm
      elsif @user_account.provider == 'lastfm'
        # Check if Last.fm username exists
        find_user = HTTParty.get(
          "http://ws.audioscrobbler.com/2.0/" +
          "?method=user.getinfo" +
          "&user=#{@user_account.username}" +
          "&api_key=#{ENV['LASTFM_KEY']}" +
          "&format=json"
        )
        # If username exists
        if find_user['error'] != 6
          url = HTTParty.get(
            "http://ws.audioscrobbler.com/2.0/" +
            "?method=user.gettopartists" +
            "&user=#{@user_account.username}" +
            "&period=3month" +
            # "&limit=100" + Note: limit defaults at 50
            "&api_key=#{ENV['LASTFM_KEY']}" +
            "&format=json"
          )
          # If user does not have any top artists in the last 3 months, take overall artists
          if url['topartists']['total'] == '0'
            url = HTTParty.get(
              "http://ws.audioscrobbler.com/2.0/" +
              "?method=user.gettopartists" +
              "&user=#{@user_account.username}" +
              "&period=overall" +
              # "&limit=100" + Note: limit defaults at 50
              "&api_key=#{ENV['LASTFM_KEY']}" +
              "&format=json"
            )
            # Get Last.fm artists
            JSON.parse(url.body)['topartists']['artist'].each do |lastfm|
              get_artists(lastfm['name'], 'lastfm')
            end
            redirect_to :back
          elsif url['topartists']['total'] != '0'
            # Get Last.fm artists
            JSON.parse(url.body)['topartists']['artist'].each do |lastfm|
              get_artists(lastfm['name'], 'lastfm')
            end
            redirect_to :back
          end
        # Else username does not exist
        else
          @user_account.destroy
          redirect_to :back
        end

      # Account other than Rdio / Last.fm?
      else
        # UserAccount.from_omniauth(env['omniauth.auth'])
      end
    end
  end

  # GET '/accounts'
  def accounts
    if current_user
      # New user accounts for Rdio & Last.fm
      @rdio_email = UserAccount.new
      @lastfm_username = UserAccount.new

      # Update events for current artists from Last.fm after account import
      current_artists.each { |a| EventWorker.perform_async(a.id) }

      # Note 1: Refacter to only run EventWorker if necessary
    end
  end

  private

  def account_params
    params.require(:user_account).permit(:provider, :email, :username, :name)
  end
  
end
