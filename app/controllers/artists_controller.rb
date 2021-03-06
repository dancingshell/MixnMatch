class ArtistsController < ApplicationController
  
  def index
    @artists = Artist.all.sort_by{ |alpha| url_encode(alpha.name.downcase) }
    @add_artist = UserArtist.new
  end

  def show
    @artist = Artist.find(params[:id])
    @artist_likers = UserArtist.where(artist: @artist)
    @artist_likers = @artist_likers.each do |liker|
      User.where(id: liker)
    end
  end

  def new
  	@artist = Artist.new
  end

  def create
    new_artist = params[:name]
    get_artists(new_artist, "MixnMatch")
  	redirect_to artists_path
  end

  def edit
  end

  private

  def artist_params
  	params.require(:aritst).permit(:name, :genre, :image)
  end

end
