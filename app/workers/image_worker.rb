class ImageWorker
  require 'erb'
  include ERB::Util
  include Sidekiq::Worker

  def perform(artist_id)

    @artist = Artist.find_by(id: artist_id)
    artist_name = @artist.name
    artist_url = JSON.parse(
      HTTParty.get(
        "http://ws.audioscrobbler.com/2.0/" +
        "?method=artist.getinfo" +
        "&artist=#{url_encode(artist_name)}" +
        # Note: look into how to connect .env to sidekiq class
        # "&api_key=#{ENV['LASTFM_KEY']}" +
        "&api_key=2d4eafcd13fe4bd7da79ea43ecd3dded" +
        "&format=json"
      ).body
    )

    if artist_url['error'] == 6
      # Note: temporary URL until Heroku deployment of artist_default.png
      @artist.update(image: 'http://brandonkwong.com/ga/mixnmatch/artist_default.png')
    elsif artist_url['artist']['image'][-1]['#text'] == ''
      # Note: temporary URL until Heroku deployment of artist_default.png
      @artist.update(image: 'http://brandonkwong.com/ga/mixnmatch/artist_default.png')
    else
      @artist.update(image: artist_url['artist']['image'][-1]['#text'])
    end

  end

end