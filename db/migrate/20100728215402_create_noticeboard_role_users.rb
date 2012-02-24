class CreateNoticeboardRoleUsers < ActiveRecord::Migration
  def self.up
    create_table :noticeboard_role_users do |t|
      t.integer :noticeboard_role_id
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :noticeboard_role_users
  end
end
