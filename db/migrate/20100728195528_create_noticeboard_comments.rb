class CreateNoticeboardComments < ActiveRecord::Migration
  def self.up
    create_table :noticeboard_comments do |t|
      t.string :title
      t.text :content
      t.integer :author_id
      t.integer :noticeboard_post_id
      t.boolean :is_publish
      t.timestamps
    end
  end

  def self.down
    drop_table :noticeboard_comments
  end
end
