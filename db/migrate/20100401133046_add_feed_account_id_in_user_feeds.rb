class AddFeedAccountIdInUserFeeds < ActiveRecord::Migration
  def self.up
    add_column :user_feeds, :feed_account_id, :integer
    remove_column :user_feeds, :category
  end

  def self.down
    add_column :user_feeds, :category, :string
    remove_column :user_feeds, :feed_account_id
  end
end
