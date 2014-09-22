class ImageWorker
  require 'erb'
  include ERB::Util
  include Sidekiq::Worker

  def perform(artist_id)

    # Note: sidekiq does not like where (use find_by)
    @artist = Artist.find_by(id: artist_id)
    artist_name = @artist.name

    @artist.update(genre:
      JSON.parse(
        HTTParty.get(
          "http://ws.audioscrobbler.com/2.0/" +
          "?method=artist.getinfo" +
          "&artist=#{url_encode(artist_name)}" +
          # Note: look into how to connect .env to sidekiq class
          # "&api_key=#{ENV['LASTFM_KEY']}" +
          "&api_key=2d4eafcd13fe4bd7da79ea43ecd3dded" +
          "&format=json"
        ).body
      )['artist']['image'][-2]['#text']
    )

  end

end