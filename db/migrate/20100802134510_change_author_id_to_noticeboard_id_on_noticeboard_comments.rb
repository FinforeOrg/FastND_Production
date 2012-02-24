class ChangeAuthorIdToNoticeboardIdOnNoticeboardComments < ActiveRecord::Migration
  def self.up
    rename_column :noticeboard_comments, :author_id, :user_id
  end

  def self.down
    rename_column :noticeboard_comments, :user_id, :author_id
  end
end
