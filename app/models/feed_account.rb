class FeedAccount < ActiveRecord::Base
  belongs_to :user
  has_one  :feed_token, :dependent => :destroy
  has_many :user_feeds, :dependent => :destroy
  has_one :keyword_column, :dependent => :destroy
  validates_presence_of :account
  accepts_nested_attributes_for :keyword_column

  def self.clear_columns_by_ids(ids)
    destroy_all(["id in (:ids)",{:ids => ids.split("_")}])
  end

  def isTwitter?
    self.category =~ /(tweet|twitter|suggested)/i
  end

  def isRss?
    self.category =~ /(rss)/i
  end

  def isLinkedin?
    self.category =~ /(linkedin|linked-in)/i
  end

  def isPodcast?
    self.category =~ /(podcast|video|audio)/i
  end

  def isChart?
    self.category =~ /(price|chart)/i
  end

  def isCompany?
    self.category =~ /(company|index|currency)/i
  end

  def isKeyword?
    self.category =~ /(keyword)/i
  end

  def isFollowable?
    isTwitter? || isCompany?
  end

  def isPortfolio?
    self.category =~ /portfolio/i
  end
end
