class AddFollowerInFeedInfos < ActiveRecord::Migration
  def self.up
    add_column :feed_infos, :follower, :integer
    add_column :feed_infos, :image, :string
  end

  def self.down
    remove_column :feed_infos, :follower
    remove_column :feed_infos, :image
  end
end
