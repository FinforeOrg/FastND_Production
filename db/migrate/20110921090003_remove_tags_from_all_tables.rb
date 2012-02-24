class RemoveTagsFromAllTables < ActiveRecord::Migration
  def self.up
    remove_column :feed_infos, :tag_geographic
    remove_column :feed_infos, :tag_profession
    remove_column :feed_infos, :tag_industry
    remove_column :users, :geographic
    remove_column :users, :industry
    remove_column :users, :profession
  end

  def self.down
  end
end
