class CreateFeedApis < ActiveRecord::Migration
  def self.up
    create_table :feed_apis do |t|
      t.string :api
      t.string :secret
      t.string :type
      t.timestamps
    end
  end

  def self.down
    drop_table :feed_apis
  end
end
