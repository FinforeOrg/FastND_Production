class CreatePopulateFeedInfos < ActiveRecord::Migration
  def self.up
    create_table :populate_feed_infos do |t|
      t.integer :feed_info_id
      t.string :profession
      t.string :geographic
      t.string :industry
      t.timestamps
    end
  end

  def self.down
    drop_table :populate_feed_infos
  end
end
