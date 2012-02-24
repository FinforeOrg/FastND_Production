class AddFeedInfoIdInUserFeedsAndMostFolloweds < ActiveRecord::Migration
  def self.up
    add_column :user_feeds, :feed_info_id, :integer
    add_column :most_followeds, :feed_info_id, :integer
  end

  def self.down
    remove_column :user_feeds, :feed_info_id
    remove_column :most_followeds, :feed_info_id
  end
end
