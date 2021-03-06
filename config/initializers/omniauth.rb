OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], scope: 'user_likes, user_birthday, user_location, public_profile, email'
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV['SPOTIFY_KEY'], ENV['SPOTIFY_SECRET'], scope: 'user-read-email user-read-private user-library-read user-library-modify'
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], scope: "userinfo.email,userinfo.profile"

    #   {
    #   :provider_ignores_state => true,
    #   :name => "google",
    #   :scope => "email, profile, plus.me, http://gdata.youtube.com",
    #   :prompt => "select_account",
    #   :image_aspect_ratio => "square",
    #   :image_size => 50
    # }
end