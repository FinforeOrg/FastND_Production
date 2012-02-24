class AddDescriptionToFeedInfos < ActiveRecord::Migration
  def self.up
    add_column :feed_infos,:description,:text
  end

  def self.down
    remove_column :feed_infos,:description
  end
end
