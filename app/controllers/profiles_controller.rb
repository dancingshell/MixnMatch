class ProfilesController < ApplicationController

  def new
    @profile = Profile.new
  end

  def create
    @profile = current_user.profiles.new(profile_params)
    if @profile.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  private

  def profile_params
    params.require(:profile).require(:summary, :orientation, :gender, :birth_m, :birth_d, :birth_y, :relationship, :friendship, :zipcode)
  end

end
