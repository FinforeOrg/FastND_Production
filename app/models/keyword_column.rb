class KeywordColumn < ActiveRecord::Base
  belongs_to :user
  belongs_to :feed_account
end
