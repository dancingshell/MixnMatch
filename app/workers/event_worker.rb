class EventWorker
  require 'erb'
  include ERB::Util
  include Sidekiq::Worker

  def perform(artist_id)

    # Note: sidekiq does not like where (use find_by)
    artist_name = Artist.find_by(id: artist_id).name

    # Get Last.fm events from artists
    url = HTTParty.get(
      "http://ws.audioscrobbler.com/2.0/" +
      "?method=artist.getevents" +
      "&artist=#{url_encode(artist_name)}" +
      # Note: look into how to connect .evn to sidekiq class
      # "&api_key=#{ENV['LASTFM_KEY']}" +
      "&api_key=2d4eafcd13fe4bd7da79ea43ecd3dded" +
      "&format=json"
    )
    @lastfm_events = JSON.parse(url.body)

    # Condtional to account for all different types of errors and instances coming from lastfm
    if @lastfm_events['error'] == 6
      # Do nothing?
    elsif @lastfm_events['events']['total'] == '0'
      # Do nothing?
    elsif @lastfm_events['events']['@attr']['total'] == '1' 
      venue = @lastfm_events['events']['event']['venue']
      event = Event.where(url: @lastfm_events['events']['event']['url']).first
      event = Event.create!(title: @lastfm_events['events']['event']['title'], venue: venue['name'], date: @lastfm_events['events']['event']['startDate'], url: @lastfm_events['events']['event']['url'], location: venue['postalcode'], lat: venue['location']['geo:point']['geo:lat'], long: venue['location']['geo:point']['geo:long'])
      EventArtist.create!(artist: artist_name, event: event) unless EventArtist.where(artist: artist_name, event: event).first
    else  
      @lastfm_events['events']['event'].each do |events|
        output = Hash.new
        events.each do |key, value|
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