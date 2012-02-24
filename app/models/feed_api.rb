class FeedApi < ActiveRecord::Base

  def self.twitter
    find_by_category('twitter')
  end

  def self.linkedin
    find_by_category('linkedin')
  end

  def self.facebook
    find_by_category('facebook')
  end

  def self.google
    find_by_category('google')
  end

  def self.portfolio
    find_by_category('google')
  end

  def self.gmail
    find_by_category('google')
  end

  def isFacebook?
    self.category =~ /(facebook)/i
  end


end