class AddMessageStatusToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :message_status, :string
  end
end
