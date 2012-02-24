class NoticeboardPost < ActiveRecord::Base
  profanity_filter :title, :content, :method => 'dictionary'
  belongs_to :noticeboard
  belongs_to :user
  has_many   :noticeboard_comments

  def total_comment
    self.noticeboard_comments.count(:all,:conditions => "is_publish IS TRUE")
  end
end
