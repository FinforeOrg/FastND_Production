class FeedToken < ActiveRecord::Base
  belongs_to :feed_account
  belongs_to :user
end
