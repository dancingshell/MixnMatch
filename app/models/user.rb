class User < ActiveRecord::Base
  has_many :authentications
  has_many :matchers, class_name: "Match", foreign_key: :matcher_id, inverse_of: :matcher
  has_many :matchees, class_name: "Match", foreign_key: :matchee_id, inverse_of: :matchee
  has_many :user_groups
  has_many :user_artists
  has_many :user_accounts
  has_many :groups, through: :user_groups
  has_many :artists, through: :user_artists
  has_many :messages, through: :matches
  has_many :profiles
  has_secure_password

  
  def self.from_omniauth(auth)
    #raise auth.inspect
    where(auth.slice(:facebook, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.oauth_token = auth.credentials.token
      # gives facebook login password so it can pass secure password validation
      user.password = "default"
      user.password_confirmation = "default"
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end 
end
