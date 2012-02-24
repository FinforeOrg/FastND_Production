class UserCompanyTab < ActiveRecord::Base
  belongs_to :user
  belongs_to :feed_info

  def self.by_user_id(user_id)
    self.find_by_sql("SELECT user_company_tabs.*,feed_infos.*,company_competitors.* FROM user_company_tabs "+
		     "LEFT OUTER JOIN users ON users.id = user_company_tabs.user_id "+
		     "LEFT OUTER JOIN feed_infos ON feed_infos.id = user_company_tabs.feed_info_id "+
		     "LEFT OUTER JOIN company_competitors ON company_competitors.feed_info_id = feed_infos.id "+
		     "WHERE users.id = #{user_id}")
  end
end
