class AddInvitationNoteOnNoticeboardUsers < ActiveRecord::Migration
  def self.up
    add_column :noticeboard_users, :invitation_note, :text
    add_column :noticeboard_users, :is_user_remove, :boolean
  end

  def self.down
    remove_column :noticeboard_users, :invitation_note
    remove_column :noticeboard_users, :is_user_remove
  end
end
