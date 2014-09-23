class AddRadiocodeToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :radio_key, :string
    add_column :artists, :top_songs_key, :string
  end
end
