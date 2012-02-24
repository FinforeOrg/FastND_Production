class CreateProfilesPopulateFeedInfosTable < ActiveRecord::Migration
  def self.up
   create_table :populate_feed_infos_profiles,:id=>false do |t|
      t.references :populate_feed_info
      t.references :profile
      t.timestamps
    end
  end

  def self.down
    drop_table :populate_feed_infos_profiles
  end

end
