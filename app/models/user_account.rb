class UserAccount < ActiveRecord::Base
  belongs_to :user


  def self.from_omniauth(auth)
    where(auth.slice(:facebook, :uid)).first_or_initialize.tap do |user_account|
      user_account.provider = auth.provider
      user_account.uid = auth.uid
      user_account.oauth_token = auth.credentials.token
      user_account.refresh_token = auth.refresh_token
      user_account.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user_account.save!
    end
  end
end
