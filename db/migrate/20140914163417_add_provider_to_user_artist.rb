class AddProviderToUserArtist < ActiveRecord::Migration
  def change
    add_column :user_artists, :provider, :string
  end
end
