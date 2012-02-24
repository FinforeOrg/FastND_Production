class CreateNoticeboards < ActiveRecord::Migration
  def self.up
    create_table :noticeboards do |t|
      t.string :name
      t.boolean :auto_publish_comment
      t.timestamps
    end
  end

  def self.down
    drop_table :noticeboards
  end
end
