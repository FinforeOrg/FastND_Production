class NoticeboardUser < ActiveRecord::Base
  belongs_to :noticeboard
  belongs_to :user
end
