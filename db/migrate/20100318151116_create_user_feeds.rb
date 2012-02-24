class CreateUserFeeds < ActiveRecord::Migration
  def self.up
    create_table :user_feeds do |t|
      t.integer :user_id
      t.string  :name
      t.string  :category
      t.string  :category_type
      t.timestamps
    end
  end

  def self.down
    drop_table :user_feeds
  end
end
