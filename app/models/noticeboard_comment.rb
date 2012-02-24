class NoticeboardComment < ActiveRecord::Base
  profanity_filter :title, :content, :method => 'dictionary'
  belongs_to :user
  belongs_to :noticeboard_post
  belongs_to :noticeboard
end
