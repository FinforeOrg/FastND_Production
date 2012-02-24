class UserFeed < ActiveRecord::Base
  belongs_to :user
  belongs_to :feed_account
  belongs_to :feed_info

  def before_destroy
    if self.feed_info
      total = self.feed_info.follower.blank? ? 0 : self.feed_info.follower - 1
      total = (total < 0) ? 0 : total
      self.feed_info.update_attribute(:follower,total)
    end
  end

  def isSuggestion?
    self.category_type =~ /(tweet|twitter|suggested)/i
  end

  def isRss?
    self.category_type =~ /(rss)/i
  end

  def isPodcast?
    self.category_type =~ /(podcast|video|audio)/i
  end

  def isChart?
    self.category_type =~ /(price|chart)/i
  end

  def isCompany?
    self.category_type =~ /(company|index|currency)/i
  end

  def isKeyword?
    self.category_type =~ /(keyword)/i
  end

  
end
