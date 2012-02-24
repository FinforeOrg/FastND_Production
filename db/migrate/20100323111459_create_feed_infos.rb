class CreateFeedInfos < ActiveRecord::Migration
  def self.up
    create_table :feed_infos do |t|
      t.string :title
      t.string :address
      t.string :category
      t.string :type
      t.timestamps
    end
  end

  def self.down
    drop_table :feed_infos
  end
end
