class UsersController < ApplicationController

  # def index
  # end

  def new
    @user = User.new
    # @user_accounts = User.user_accounts.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # session[:user_id] = @user.id.to_s
      redirect_to root_path
    else
      render 'new'
    end
  end

  # def edit
  # end

  # def update
  # end

  # def destroy
  # end

  protected

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

end
