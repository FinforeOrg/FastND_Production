class CreateNoticeboardUsers < ActiveRecord::Migration
  def self.up
    create_table :noticeboard_users do |t|
      t.integer :user_id
      t.integer :noticeboard_id
      t.boolean :is_active
      t.timestamps
    end
  end

  def self.down
    drop_table :noticeboard_users
  end
end
