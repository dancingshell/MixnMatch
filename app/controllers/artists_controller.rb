class ArtistsController < ApplicationController
  def new
  	@artist = Artist.new
  end

  def create
  	@artist = Artist.new(artist_params)
  	if @artist.save
  		redirect to root_path
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

  private
  def artist_params
  	params.require(:aritst).permit(:name, :genre)
  end
end
