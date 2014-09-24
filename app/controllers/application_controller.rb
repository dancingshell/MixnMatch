class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery

  require 'erb'
  include ERB::Util

  before_action :header
  helper_method :current_user
  helper_method :current_artists
  
  private

  def header
    @user_login = User.new
    @is_login = true
  end

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
    # Create new artist in DB for each artist imported if artist does not already exist
    artist = Artist.where(name: artist_name).first
    artist = Artist.create!(name: artist_name) unless artist
    ImageWorker.perform_async(artist.id)

    # Make a join table match between that user and their bands
    user_artist = UserArtist.where(user: current_user, artist: artist).first
    UserArtist.create!(user: current_user, artist: artist, provider: provider) unless user_artist
  end

end
