class Artist < ActiveRecord::Base
  has_many :user_artists
  has_many :event_artists
end
