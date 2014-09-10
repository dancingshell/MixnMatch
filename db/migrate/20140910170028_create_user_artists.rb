class CreateUserArtists < ActiveRecord::Migration
  def change
    create_table :user_artists do |t|
      t.references :user, index: true
      t.references :artist, index: true

      t.timestamps
    end
  end
end
