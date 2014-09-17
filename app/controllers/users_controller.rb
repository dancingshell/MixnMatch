class UsersController < ApplicationController

  def index
  end

  def show
  end

  def new
    @user = User.new

    @user_login = User.new
    @is_login = true
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id.to_s
      redirect_to n
    else
      render 'new'
    end
  end

  def edit
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :provider)
  end

end
