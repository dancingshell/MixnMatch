class UserAccountsController < ApplicationController

  # POST '/user_accounts'
  def create
    @user_account = current_user.user_accounts.new(account_params)
    # checks if last.fm user exists
    @username = params[:user_account][:username]
    find_user = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=user.getinfo&user=#{@username}&api_key=#{ENV['LASTFM_KEY']}&format=json")
    unless find_user["error"] && find_user["error"] == 6
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
          
          url = HTTParty.get(
            "http://ws.audioscrobbler.com/2.0/" +
            "?method=user.gettopartists" +
            "&user=#{@user_account.username}" +
            "&period=3month" +
            # "&limit=100" + Note: limit defaults at 50
            "&api_key=" + ENV['LASTFM_KEY'] +
            "&format=json"
          )
          # if user does not have any top artists in the last 3 months, take overall artists
          if url["topartists"]["total"] == "0"
            url = HTTParty.get(
            "http://ws.audioscrobbler.com/2.0/" +
            "?method=user.gettopartists" +
            "&user=#{@user_account.username}" +
            "&period=overall" +
            # "&limit=100" + Note: limit defaults at 50
            "&api_key=" + ENV['LASTFM_KEY'] +
            "&format=json")
            @lastfm = JSON.parse(url.body)
              # Get Last.fm artists
            @lastfm['topartists']['artist'].each do |lastfm|
              get_artists(lastfm['name'], 'lastfm')
            end
            redirect_to :back
          else
            @lastfm = JSON.parse(url.body)
            # Get Last.fm artists
            @lastfm['topartists']['artist'].each do |lastfm|
              get_artists(lastfm['name'], 'lastfm')
            end
            redirect_to :back
          end
        end
      end
    else
      @user_account.destroy
      redirect_to :back
    end
  end

  # GET '/accounts'
  def accounts
    # User accounts for Rdio & Last.fm
    @rdio_email = UserAccount.new
    @lastfm_username = UserAccount.new

    # Artist.where(genre: nil).each do |artist|
    #   artist.delay.update!(genre:
    #     JSON.parse(
    #       HTTParty.get(
    #         "http://ws.audioscrobbler.com/2.0/" +
    #         "?method=artist.getinfo" +
    #         "&artist=" + url_encode(artist.name) +
    #         "&api_key=" + ENV['LASTFM_KEY'] +
    #         "&format=json"
    #       ).body
    #     )['artist']['image'][-2]['#text']
    #   )
    # end

  end

  private

  def account_params
    params.require(:user_account).permit(:provider, :email, :username, :name)
  end
  
end
