class UsersController < ApplicationController

  def index
  end

  def show
  end

  def new
    @navbar = false
    @user = User.new

    @user_login = User.new
    @is_login = true
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id.to_s
      redirect_to accounts_path
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
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :provider)
  end

end
