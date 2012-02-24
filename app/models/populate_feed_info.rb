class PopulateFeedInfo < ActiveRecord::Base
  belongs_to :feed_info
  has_and_belongs_to_many :profiles  
  def self.find_by_tags(user, category)
    self.all(:include => :feed_info,
              :conditions => "populate_feed_infos.profession ~* '#{user.profession}' AND 
                       populate_feed_infos.geographic ~* '#{user.geographic}' AND 
                       populate_feed_infos.industry ~* '#{user.industry}' AND 
                       feed_infos.category ~* '#{category}'",
              :order => "feed_infos.title")
  end
  
end
