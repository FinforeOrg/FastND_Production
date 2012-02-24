class ChangeTypeCategoryTypeInFeedInfos < ActiveRecord::Migration
  def self.up
    rename_column :feed_infos,:type,:category_type
  end

  def self.down
    rename_column :feed_infos,:category_type,:type
  end
end
