class ModifyAccessTokensAndUsers < ActiveRecord::Migration
  def self.up
    remove_column :users,:active_token_id
    remove_column :access_tokens, :active
    add_column    :access_tokens,:uid,:string
  end

  def self.down
    add_column :users,:active_token_id,:integer
    remove_column :access_tokens, :uid
    add_index :users, :active_token_id
  end
end
