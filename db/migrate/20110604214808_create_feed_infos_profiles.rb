class CreateFeedInfosProfiles < ActiveRecord::Migration
  def self.up
    create_table :feed_infos_profiles,:id=>false do |t|
      t.references :feed_info
      t.references :profile
      t.timestamps
    end
  end

  def self.down
    drop_table :feed_infos_profiles
  end
end
