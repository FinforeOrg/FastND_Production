class ModifyFeedInfos < ActiveRecord::Migration
  def self.up
    remove_column :feed_infos, :category_type
    add_column :feed_infos, :tag_profession, :string
    add_column :feed_infos, :tag_geographic, :string
    add_column :feed_infos, :tag_industry, :string
  end

  def self.down
    add_column :feed_infos, :category_type, :string
    remove_column :feed_infos, :tag_profession
    remove_column :feed_infos, :tag_geographic
    remove_column :feed_infos, :tag_industry
  end
end
