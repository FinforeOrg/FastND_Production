class CreateNoticeboardPosts < ActiveRecord::Migration
  def self.up
    create_table :noticeboard_posts do |t|
      t.integer :noticeboard_id
      t.string :title
      t.text :content
      t.boolean :is_publish
      t.integer :user_id
      t.string :tags
      t.timestamps
    end
  end

  def self.down
    drop_table :noticeboard_posts
  end
end
