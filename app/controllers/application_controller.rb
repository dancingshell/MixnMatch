class ApplicationController < ActionController::Base

  require "erb"
  include ERB::Util
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery
  helper_method :current_user
  helper_method :current_artists
  before_action :header
  

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

  def header
    @user_login = User.new
    @is_login = true
  end


  def get_events(artist_name)

    if artist_name.name.include?(" ")
      new_name = artist_name.name.gsub!(" ", '+')
    else
      new_name = artist_name.name
    end

    url = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=artist.getevents&artist=#{new_name}&api_key=" + ENV['LASTFM_KEY'] + "&format=json")
    @lastfm_events = JSON.parse(url.body)

    #Condtional to account for all different types of errors and instances coming from lastfm
    if  @lastfm_events['error'] == 6
    elsif @lastfm_events['events']['total'] == "0" 
    elsif @lastfm_events['events']['@attr']['total'] == "1" 
      venue = @lastfm_events['events']['event']['venue']
      event = Event.where(url: @lastfm_events['events']['event']['url']).first
      event = Event.create!(title: @lastfm_events['events']['event']['title'], venue: venue['name'], date: @lastfm_events['events']['event']['startDate'], url: @lastfm_events['events']['event']['url'], location: venue['postalcode'], lat: venue['location']['geo:point']['geo:lat'], long: venue['location']['geo:point']['geo:long'])
      EventArtist.create!(artist: artist_name, event: event) unless EventArtist.where(artist: artist_name, event: event).first
    else  
      @lastfm_events['events']['event'].each do |e|
        output = Hash.new
        e.each do |key, value|
          output[key] = value
        end
        output

        event = Event.where(url: output['url']).first
        event = Event.create!(title: output['title'], venue: output['venue']['name'], location: output['venue']['postalcode'], date: output['startDate'], url: output['url'], lat: output['venue']['location']['geo:point']['geo:lat'], long: output['venue']['location']['geo:point']['geo:long']) unless event
        
        EventArtist.create!(artist: artist_name, event: event) unless EventArtist.where(artist: artist_name, event: event).first
      end
    end
  end
end
