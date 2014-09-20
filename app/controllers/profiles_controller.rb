class ProfilesController < ApplicationController

  def new
    @profile = Profile.new
  end

  def create
    # create_profile is necessary for has_one association
    @profile = current_user.create_profile(profile_params)
    if @profile.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    if current_user
      @profile = current_user.profile
    else
      redirect_to welcome_path
    end
  end

  def update
    if current_user.profile.update_attributes(profile_params)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:summary, :orientation, :gender, :birthday, :relationship, :friendship, :zipcode, :username, :user_id)
  end

end
