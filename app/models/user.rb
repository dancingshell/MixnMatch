class User < ActiveRecord::Base
  has_many :matchers, class_name: "Match", foreign_key: :matcher_id, inverse_of: :matcher
  has_many :matchees, class_name: "Match", foreign_key: :matchee_id, inverse_of: :matchee
  has_many :user_groups
  has_many :user_artists
  has_many :groups, through: :user_groups
  has_many :artists, through: :user_artists
  has_many :messages, through: :matches
end
