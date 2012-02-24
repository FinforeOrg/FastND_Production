class AddUserProfileToAccessToken < ActiveRecord::Migration
  def self.up
    add_column :access_tokens, :user_profile, :text
  end

  def self.down
    remove_column :access_tokens, :user_profile
  end
end
