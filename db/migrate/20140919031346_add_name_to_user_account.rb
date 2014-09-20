class AddNameToUserAccount < ActiveRecord::Migration
  def change
    add_column :user_accounts, :name, :string
  end
end
