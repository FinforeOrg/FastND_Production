class ChangeTypeTagsInFeedInfos < ActiveRecord::Migration
  def self.up
    change_column :feed_infos, :tag_profession, :text
    change_column :feed_infos, :tag_geographic, :text
    change_column :feed_infos, :tag_industry, :text
  end

  def self.down
    change_column :feed_infos, :tag_profession, :string
    change_column :feed_infos, :tag_geographic, :string
    change_column :feed_infos, :tag_industry, :string
  end
end
