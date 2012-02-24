class NoticeboardRoleUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :noticeboard_role
  belongs_to :noticeboard
end
