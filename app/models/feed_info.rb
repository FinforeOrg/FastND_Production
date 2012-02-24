class FeedInfo < ActiveRecord::Base
  has_many :user_feeds, :dependent => :destroy
  has_many :populate_feed_infos, :dependent => :destroy
  has_many :price_tickers, :dependent => :destroy
  has_many :user_company_tabs, :dependent => :destroy
  has_one  :company_competitor, :dependent => :destroy
  has_and_belongs_to_many :profiles
  
  def self.filter_feeds_data(conditions, limit_no, page)
    sql = prepare_sql(conditions)
    
    unless sql.match(/ORDER BY/i)
      sql += " ORDER BY feed_infos.title ASC"
    else
      sql += ",feed_infos.title ASC" 
    end

    if limit_no.to_i == 25 || limit_no.blank?
      sql += " LIMIT #{limit_no}" unless limit_no.blank?
      find_by_sql(sql)
    else
      paginate_by_sql(sql,:page => page,:per_page => limit_no)
    end
  end

  def self.all_with_competitor(conditions)
    results = self.all(:include => [:company_competitor, :profiles], :conditions => conditions)
    results = results.sort_by{|r| r.profiles.size}.reverse if conditions.match(/profiles.id IN/i)
    return results
  end

  def self.all_sort_title(conditions)
    find(:all, :include=>[:profiles, :price_tickers],
                    :select=> custom_selections,
                    :conditions => conditions, 
                    :order => "feed_infos.title")
  end
  
  def self.search_populates(add_condition,is_company_tab=false)
    sql = prepare_sql(add_condition,is_company_tab)
    sql += " LIMIT 4"
    results = find_by_sql(sql)
    
    if results.size < 4 && !is_company_tab
      current_ids = results.map(&:id).join(",")
      add_condition = " AND feed_infos.id NOT IN (#{current_ids})"
      more_results = filter_feeds_data(add_condition,(4-(results.size)),1)
      results += more_results
    end
    
    results  
  end
  
  def self.default_price_populate
    find(:all,:conditions => "title LIKE '%DJ Industrial%' OR title LIKE '%Equity Indi%'")
  end

  def isSuggestion?
    self.category =~ /(tweet|twitter|suggest)/i
  end

  def isRss?
    self.category =~ /(rss)/i
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
  
  private

    def self.custom_selections
      "feed_infos.id, feed_infos.title, feed_infos.category, feed_infos.address,feed_infos.is_populate"
    end
    
    def self.custom_joins
      " LEFT OUTER JOIN feed_infos_profiles ON feed_infos_profiles.feed_info_id = feed_infos.id LEFT OUTER JOIN profiles ON profiles.id = feed_infos_profiles.profile_id"
    end
    
    def self.company_tab_join
      " LEFT OUTER JOIN company_competitors ON company_competitors.feed_info_id = feed_infos.id"
    end
    
    def self.prepare_sql(conditional,is_company_tab=false)
      sql = "SELECT #{custom_selections}, COUNT(profiles.id) as count_profile"
      sql += " FROM feed_infos #{custom_joins}"
      sql += company_tab_join if is_company_tab  
      sql += " WHERE #{conditional}"
      sql += " GROUP BY #{custom_selections}"
      sql += " ORDER BY count_profile DESC" if conditional.match(/profiles.id IN/i)
      return sql
    end

end
