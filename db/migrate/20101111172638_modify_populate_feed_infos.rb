class ModifyPopulateFeedInfos < ActiveRecord::Migration
  def self.up
    add_column :populate_feed_infos, :is_company_tab, :boolean
  end

  def self.down
    remove_column :populate_feed_infos, :is_company_tab
  end
end
