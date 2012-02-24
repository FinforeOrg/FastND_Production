class User < ActiveRecord::Base
  #attr_accessor :password, :password_confirmation

  acts_as_authentic do |auth|
    auth.email_field = :email_work
    auth.ignore_blank_passwords = true if auth.email_field.blank?
    auth.validate_password_field = false if auth.email_field.blank?
    auth.validate_email_field = false if auth.email_field.blank?
    auth.validate_login_field = false if auth.email_field.blank?
  end

  #validates_uniqueness_of :email_work, :message => "is already taken.", :if => :has_email?
  #validates_presence_of :profession, :on=>:update, :message => "is required", :if => :has_email?
  #validates_presence_of :geographic, :on=>:update, :message => "is required", :if => :has_email?
  #validates_presence_of :industry, :on=>:update, :message => "is required", :if => :has_email?
  validates_format_of :email_work, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "is invalid", :if => :has_email?
 
  has_many :feed_accounts, :dependent => :destroy
  has_many :user_feeds, :dependent => :destroy
  has_many :keyword_columns, :dependent => :destroy
  has_many :feed_tokens, :dependent => :destroy
  has_many :access_tokens, :dependent => :destroy
  has_many :noticeboard_users
  has_many :noticeboard_comments
  has_many :noticeboard_posts
  has_many :noticeboard_role_users
  has_many :user_company_tabs, :dependent => :destroy
  has_and_belongs_to_many :profiles
  has_one  :linkedin_token, :dependent => :destroy

  def has_columns?
    (self.feed_accounts.count(:all) > 0)
  end

  def before_save
    self.is_online = true
    #self.industry='All Sectors' if self.industry == 'All'
    #self.profession='Asset Management' if self.profession == 'Asset Mguugnt'
    #self.profession='Communications' if self.profession == "Communications & Media"
  end
  
  def self.find_public_profile(pids)
    _users = find(:all,:include=>:profiles,:select=>"profiles.id,users.id,users.is_public",:conditions=>"users.is_public IS TRUE")
    _return = nil
    _garbage = []
    _users.each do |_user|
      _remain = pids - _user.profiles.map(&:id)
      if _remain.size < 1
        _return = _user
        break
      elsif _remain.size < _user.profiles.size 
        if _garbage.size < 1
          _garbage.push({:user => _user,:remain_size => _remain.size}) 
        else
          last_data = _garbage[0]
          if last_data[:remain_size].to_i > _remain.size
            _garbage.shift
            _garbage.push({:user => _user,:remain_size => _remain.size})
          end  
        end
      end
    end  
    _return = _garbage.shift[:user] if _return.blank? && _garbage.size > 0 
    return _return
  end

  def has_email?
    !self.email_work.blank? && self.oauth_token.blank?
  end

  def not_social_login?
    !self.oauth_token.blank?
  end
  
  def focuses_by_category
    categories = ProfileCategory.all
    focuses = categories.map{|c| [c.title, self.profiles.find_all_by_profile_category_id(c.id).map(&:title).join(',')]}
    return focuses
  end

end
