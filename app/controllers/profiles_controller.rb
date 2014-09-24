class ProfilesController < ApplicationController

  def index
  end

  def new
    @profile = Profile.new
  end

  def create
    # create_profile is necessary for has_one association
    @profile = Profile.new(profile_params)
    @profile.user = current_user
    if @profile.save
      redirect_to accounts_path
    else
      render 'new'
    end
  end

  def edit
    if current_user
      @profile = Profile.find(params[:id])
    else
      redirect_to welcome_path
    end
  end

  def update
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(profile_params)
      redirect_to user_path(@profile.username)
    else
      render 'edit'
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:summary, :orientation, :gender, :birthday, :relationship, :friendship, :zipcode, :username, :user_id)
  end

end
