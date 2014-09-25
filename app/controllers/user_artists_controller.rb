class UserArtistsController < ApplicationController

  def create
  	user_artist = UserArtist.new(artist_id: params[:artist_id])
  	user_artist.user = current_user
  	user_artist.provider = "MixnMatch"
  	if user_artist.save
  		redirect_to :back
  	else
  		render 'new'
  	end
  end

  def index
  	@artists = Artist.all
  end

  def show
  end

  def edit
  end

  def destroy
    UserArtist.find_by(user_id: current_user.id, artist_id: params[:artist_id]).destroy
    redirect_to :back
  end

  private
  def user_artist_params
  	params.require(:user_artist).permit(:artist_id, :user_id, :provider)
  end
end
