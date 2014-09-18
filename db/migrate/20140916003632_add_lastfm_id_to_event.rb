class AddLastfmIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :lastfm_id, :string
  end
end
