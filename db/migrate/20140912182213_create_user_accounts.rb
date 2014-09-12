  class CreateUserAccounts < ActiveRecord::Migration
  def change
    create_table :user_accounts do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid
      t.string :oauth_token
      t.string :refresh_token
      t.string :email
      t.string :username
      t.string :oauth_expires_at

      t.timestamps
    end
  end
end
