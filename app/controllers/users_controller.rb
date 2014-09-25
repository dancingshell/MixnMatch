class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    if Profile.find_by(username: params[:id]).nil?
      redirect_to root_path
    else
      @match = Match.new
      @user = Profile.find_by(username: params[:id]).user
      @profile = Profile.find_by(user_id: @user.id)
      @artists = @user.artists.sort_by{ |alpha| url_encode(alpha.name.downcase) }
      @add_artist = UserArtist.new

      @location = @profile.zipcode

      @current_user_artists = current_user.artists.map(&:name)
      @user_artists = @user.artists.map(&:name)
      # finds artists that are common between current user and other users
      @count = @user_artists & @current_user_artists
  
      # secret match potion
      if @current_user_artists.length > @user_artists.length
        @large_count = @count.length.to_f / @current_user_artists.length
        @small_count = @count.length.to_f / @user_artists.length
      else
        @large_count = @count.length.to_f / @user_artists.length
        @small_count = @count.length.to_f / @current_user_artists.length
      end
      
      @large_count = (@large_count + @small_count) / 2
      @large_count *= 100
      @small_count *= 100
      @match_percent = (@large_count + @small_count) / 2

      # if number is devided by 0 (returns NaN) change to 0
      @match_percent = 0 if @match_percent.nan?
      @match_percent = @match_percent.floor

    end
  end

  def new
    @navbar = false
    @user = User.new
    @user_login = User.new
    @is_login = true
    @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: 201, acl: :public_read)
  end

  def create
    @user = User.new(user_params)
    @user.avatar = params[:user][:avatar].last if params[:user][:avatar]
    if @user.save
      session[:user_id] = @user.id.to_s
      redirect_to new_profile_path
    else
      redirect_to :back
    end
  end

  def edit
    if current_user == User.find(params[:id])
      @user = current_user
      @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: 201, acl: :public_read)
    else
      redirect_to welcome_path
    end
  end

  def update
    if current_user.update_attributes(user_params)
      current_user.avatar = params[:user][:avatar].last if params[:user][:avatar]
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :avatar, :password, :password_confirmation, :provider)
  end

end
