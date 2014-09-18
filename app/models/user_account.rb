class UserAccount < ActiveRecord::Base
  belongs_to :user


  def self.from_omniauth(auth)
    where(auth.slice(:spotify, :uid)).first_or_initialize.tap do |account|
      account.provider = auth.provider
      account.uid = auth.uid
      account.name = auth.info.name
      account.oauth_token = auth.credentials.token
      account.refresh_token = auth.credentials.refresh_token
      account.oauth_expires_at = Time.at(auth.credentials.expires_at)
      account.save!
    end
  end
end
