class Noticeboard < ActiveRecord::Base
  has_many :noticeboard_posts
  has_many :noticeboard_users
  has_many :noticeboard_comments
  has_many :noticeboard_role_users
  has_many :users, :through => :noticeboard_users
end
