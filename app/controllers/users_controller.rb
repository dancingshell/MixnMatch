class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @match = Match.new
    @user = User.find_by(params[:username])
    @profile = Profile.find_by(user_id: @user.id)
    @artists = @user.artists.sort_by{ |alpha| url_encode(alpha.name.downcase) }
    
    @user_artists = current_user.artists.map(&:name)
    @friend_artists = @user.artists.map(&:name)
    @count = @user_artists & @friend_artists
    @love_results = @count.count
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
      render 'new'
    end
  end

  def edit
    if current_user == User.find(params[:id])
      @user = current_user
    else
      redirect_to welcome_path
    end
  end

  def update
    if current_user.update_attributes(user_params)
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
