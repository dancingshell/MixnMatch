class ApplicationController < ActionController::Base

  require "erb"
  include ERB::Util
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery
  helper_method :current_user
  helper_method :current_artists
  
  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def current_artists
    #Find all the user artists of the current_user
    user_artists = UserArtist.where(user_id: current_user.id.to_s)
    #Create an array of all the artist_ids for those user_artists
    artists = user_artists.map(&:artist_id)
    #Find the artists associated with those user_artist
    Artist.where(id: artists)
  end

  def get_artists(artist_name, provider)
    # create new artist in DB for each artist imported if artist does not already exist
    artist = Artist.where(name: artist_name).first
    artist = Artist.create!(name: artist_name) unless artist
    #make a join table match between that user and their bands
    user_artist = UserArtist.where(user: current_user, artist: artist).first
    UserArtist.create!(user: current_user, artist: artist, provider: provider) unless user_artist
  end
end
