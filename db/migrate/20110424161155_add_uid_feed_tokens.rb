class AddUidFeedTokens < ActiveRecord::Migration
  def self.up
    add_column :feed_tokens, :uid, :string
  end

  def self.down
    remove_column :feed_tokens, :uid
  end
end
