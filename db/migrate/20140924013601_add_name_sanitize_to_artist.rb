class AddNameSanitizeToArtist < ActiveRecord::Migration
  def change
    add_column :artists, :name_sanitize, :string
  end
end
