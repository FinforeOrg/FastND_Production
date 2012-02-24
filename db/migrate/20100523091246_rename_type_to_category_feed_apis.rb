class RenameTypeToCategoryFeedApis < ActiveRecord::Migration
  def self.up
    rename_column :feed_apis, :type, :category
  end

  def self.down
    rename_column :feed_apis, :category, :type
  end
end
