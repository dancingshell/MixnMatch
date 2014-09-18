class ArtistsController < ApplicationController
  def new
  	@artist = Artist.new
  end

  def create
    new_artist = params[:name]
    get_artists(new_artist, "MixnMatch")
  	redirect_to artists_path
  end

  def index
  	@artists = Artist.all
  end

  def show
  end

  def edit
  end

  def remove_user_artist
    user_artist = UserArtist.where(artist_id: params[:id], user_id: current_user).first
    raise user_artist.inspect
    user_artist.destroy
    redirect_to artists_path
  end

  private
  def artist_params
  	params.require(:aritst).permit(:name, :genre)
  end
end
