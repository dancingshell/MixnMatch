class Event < ActiveRecord::Base
  has_many :event_artists
  has_many :groups
end
