class CreateEventArtists < ActiveRecord::Migration
  def change
    create_table :event_artists do |t|
      t.references :artist, index: true
      t.references :event, index: true

      t.timestamps
    end
  end
end
