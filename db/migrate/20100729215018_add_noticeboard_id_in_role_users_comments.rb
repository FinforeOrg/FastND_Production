class AddNoticeboardIdInRoleUsersComments < ActiveRecord::Migration
  def self.up
    add_column :noticeboard_role_users, :noticeboard_id, :integer
    add_column :noticeboard_comments, :noticeboard_id, :integer
  end

  def self.down
    remove_column :noticeboard_role_users, :noticeboard_id, :integer
    remove_column :noticeboard_comments, :noticeboard_id, :integer
  end
end
