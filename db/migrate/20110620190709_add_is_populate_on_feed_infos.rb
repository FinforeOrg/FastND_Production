class AddIsPopulateOnFeedInfos < ActiveRecord::Migration
  def self.up
    add_column :feed_infos,:is_populate,:boolean
  end

  def self.down
    remove_column :feed_infos,:is_populate
  end
end
