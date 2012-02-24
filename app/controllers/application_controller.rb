class ApplicationController < ActionController::Base
  ERR_AUTH = "NotAuthorizedAccess"
  ERR_LOGIN = "LoginInvalid"
  EMAIL_REGEX = Regexp.new('^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,6}$',Regexp::IGNORECASE)
  REGEX_URL = /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix

  include ExceptionLoggable
  require 'logger'
  filter_parameter_logging :password, :password_confirmation
  helper :all # include all helpers, all the time
  helper_method :current_user_session, :current_user
  protect_from_forgery
  before_filter :require_user
  
  private

  def local_request?
    false
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    unless params[:auth_token].blank?
      @current_user_session = UserSession.new(User.find_by_single_access_token(params[:auth_token]))
      @current_user_session.save
    else
      @current_user_session = UserSession.find
    end
    rescue => e
      @current_user_session
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    accident_alert(ERR_AUTH) if !current_user
  end
  
  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to users_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def create_or_update_feed_info(title,address, category = '')
    @user = current_user if @user.blank?
    feed_info = (category == "Chart") ? FeedInfo.find_by_title(title) : FeedInfo.find_by_address(address)
    
    unless feed_info
       feed_info = FeedInfo.create({:title => title,
                                    :address => address,
                                    :follower => 1,
                                    :category => category})
       feed_info.profiles << @user.profiles
    end
    return feed_info
  end

  def create_keywords(keys,user_id,account_id, category = '')
    i = 0
    until i > keys.size-1
      keywords = keys[i..(i+2)].to_sentence({:last_word_connector => ", ", :two_words_connector => ", "})
      KeywordColumn.create({:keyword=>keywords,:is_aggregate=>false,:follower=>0,:user_id => user_id,:feed_account_id=>account_id})
      i += 3
    end

    keys.each do |key|
      create_or_update_feed_info(key,category)
    end
  end

  def render_400()
    log_exception(exception)
  end

  def render_422(exception)
    log_exception(exception)
  end

  def render_500(exception)
    log_exception(exception)
  end
    
  def feed_info_complain(category)
      require 'smtp-tls'
      @user = current_user if @user.blank?
      Resque.enqueue(Finfores::Backgrounds::EmailAlert, "missing_suggestion", {:user=>@user.id, :category=>category}.to_yaml)
      #Finfores::Jobs::AlertWorker.new("missing_suggestion", {:user=>@user.id, :category=>category}.to_yaml)
  end  
    
  def create_feed_account(column)
    return FeedAccount.create({:name => column + ' column',:account => column,:category => column,:user_id => @user.id}) 
  end    
    
  def start_autopopulate
      @user = current_user if @user.blank?
      ['rss', 'podcast', 'chart'].each do |column|
         @conditions = ""
         send("#{@category}_conditions")
         feed_account = create_feed_account(column) if column != 'chart'
         prepare_profiles_condition(@user)
         @conditions += " AND feed_infos.is_populate IS TRUE"
         @feed_infos = FeedInfo.search_populates(@conditions) 
          
         if column == 'chart' && @feed_infos.size < 1
           @feed_infos = FeedInfo.default_price_populate
         end
          
         @feed_infos.each do |feed_info|
           feed_account = create_feed_account(column)  if column == 'chart'
           create_user_feed(feed_account.id, feed_info.address, feed_info.id, column)
         end
          
         feed_info_complain(column) if @feed_infos.size < 1
       end
       
       #create populate for company tabs
       all_companies_conditions
       profile_ids = @user.profiles.without('professi').map(&:id).join(',')
       @conditions += " AND profiles.id IN (#{profile_ids})" if !profile_ids.blank?
       tab_infos = FeedInfo.search_populates(@conditions,true)
       
       tab_infos.each do |company_tab|
         UserCompanyTab.create({:user_id => @user.id, :feed_info_id => company_tab.id, :follower => 100, :is_aggregate => false})
       end
       
  end
  
    def company_conditions
      @conditions += "(feed_infos.category ~* 'Company|Index|Currency'"
      @conditions += " OR (feed_infos.address ~* E'^\\k*' AND feed_infos.address !~* E'\\s+'))"
      @conditions += " AND #{with_http(false)} AND feed_infos.category !~* 'Chart'"
    end
    
    def all_companies_conditions
      company_conditions
      @conditions += " AND company_competitors.keyword IS NOT NULL"
    end
    
    def rss_conditions
      @conditions = "feed_infos.category ~* 'Rss' AND #{with_http} AND feed_infos.address !~* '(#{podcast_id}|youtube)'"
    end
    
    def podcast_conditions
      @conditions += "feed_infos.category ~* 'Podcast' AND #{with_http} AND feed_infos.address !~* 'youtube'"
      #@conditions += " AND feed_infos.address ~* '(#{podcast_id})'"
    end
    
    def chart_conditions
      #@conditions += "feed_infos.title != feed_infos.address AND feed_infos.address IS NOT NULL"
      #@conditions += " AND feed_infos.address != '' AND feed_infos.category ~* 'Chart'"
      #@conditions += " AND feed_infos.title IS NOT NULL AND feed_infos.title != ''"
      @conditions += "feed_infos.category ~* 'Chart' AND feed_infos.title IS NOT NULL AND feed_infos.title != ''"
      @conditions += " AND price_tickers.feed_info_id = feed_infos.id"
    end  
   
    def twitter_conditions
      @conditions += "feed_infos.category ~* 'Twitter' AND #{with_http(false)}"
    end
    
    def with_http(is_true=true)
      operator = is_true ? "~*" : "!~*"
      return "feed_infos.address #{operator} '(http|feed|https)://'"
    end
    
    def podcast_id
      return "podcast|audio|media|vodcast|video|mp3"
    end
    
    def prepare_profiles_condition(user=current_user)
      profile_ids = user.profiles.map(&:id).join(',')
      @conditions += " AND profiles.id IN (#{profile_ids})" unless profile_ids.blank?
    end

  def create_user_feed(account, address, feed_info, name)
     @user = current_user if @user.blank?
      return UserFeed.create({:feed_account_id => account, :feed_info_id => feed_info,
                              :name => address, :category_type => name, :user_id => @user.id })

  end   

  def error_object(message)
    {:error=>message}
  end

  def accident_alert(message)
    store_location
    respond_to do |format|
      format.html { render :text => message}
      format.xml  { render :xml => error_object(message) }
      format.fxml { render :fxml => error_object(message) }
      format.json { render :json => error_object(message) }
    end
  end
  
  def display_rescue(e)
   if current_user || params[:auth_token] || params[:finfore_token]
     accident_alert(e.to_s)    
   else
     accident_alert(ERR_AUTH)
   end
  end

  def respond_to_do(format, response, includes = [], only = [], except = [])
    format.html # index.html.erb
    format.json { render :json => response.to_json(:include => includes),:status => 200} #, :except=> except, :only => only }
    format.xml {  render :xml  => response.to_xml( :include => includes),:status => 200} #, :except=> except, :only => only }
    format.fxml { render :fxml => response.to_fxml(:include => includes)} #, :except=> except, :only => only }
  end

  def respond_error_to_do(format, response, html_action)
    format.html  { render :action => html_action }
    format.xml   { render :xml    => response.errors, :status => :unprocessable_entity }
    format.json  { render :json   => response.errors, :status => :unprocessable_entity }
    format.fxml  { render :fxml   => response.errors }
  end

  def get_request_token(api)
    consumer = get_consumer(api)
    request_token = consumer.get_request_token({:oauth_callback => @callback_url},more_options(api.category))
    return request_token
  end

  def get_consumer(api)
    client_options = send(api.category+"_options")
    consumer = OAuth::Consumer.new(api.api, api.secret, client_options)
    return consumer
  end

  def google_options
    return { :site => 'https://www.google.com',
             :request_token_path => '/accounts/OAuthGetRequestToken',
             :access_token_path => '/accounts/OAuthGetAccessToken',
             :authorize_path => '/accounts/OAuthAuthorizeToken'
           }
  end

  def twitter_options
    return {:site => 'https://api.twitter.com', :authorize_path => '/oauth/authorize' }
  end

  def linkedin_options
    return {  :site => 'https://api.linkedin.com',
              :request_token_path => '/uas/oauth/requestToken',
              :access_token_path => '/uas/oauth/accessToken',
              :authorize_path => '/uas/oauth/authorize',
              :scheme => :header
            }
  end

  def more_options(category)
    options = {}
    if category.scan(/google|gmail/i).size > 0
      scopes = ["http://www.google.com/m8/feeds/", "http://finance.google.com/finance/feeds/", "https://mail.google.com/", "http://www.google.com/reader/api", "https://www.google.com/calendar/feeds/", "http://gdata.youtube.com"]
      #"https://mail.google.com/mail/feed/atom/"
      options = {:scope => scopes.join(" ")}
    end
    return options
  end

  def get_default_callback
    url_query = current_user ? "finfore_token=#{current_user.single_access_token}" : ""
    return "http://#{request.host}/feed_accounts/column_callback?#{url_query}"
  end

  def get_callback
    @cat = get_random_token if @cat.blank?
    callback_url = get_default_callback  
    arbiter = (callback_url.scan(/\?/i).size > 0) ? "&" : "?"
    @callback_url = callback_url+"#{arbiter}cat=#{@cat}"
  end

  def get_random_token
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    return (0...16).map{ chars[rand(chars.size-1)] }.join
  end

  def get_failed_message
    "Sorry - your request does not meet requirements"
  end

  def get_profile_network(access_token,api,stored_data)
    if api.category == "linkedin"
      person = Nokogiri::XML::Document.parse(access_token.get('/v1/people/~:(id,first-name,last-name)').body).xpath('person')
      person_hash = {'uid' => person.xpath('id').text, 'provider' => api.category, 'name' => "#{person.xpath('first-name').text} #{person.xpath('last-name').text}"}
    elsif api.category == "twitter"
      person = MultiJson.decode(access_token.get('/1/account/verify_credentials.json').body)
      person_hash = {'uid' => person['screen_name'],'name' => person['name'], 'provider' => api.category}
    elsif api.category == "facebook"
      person = FGraph.me(:access_token => access_token['access_token'])
      facebook_email = person.parsed_response['email']
      facebook_email = person.parsed_response['name'].gsub(/\W/i,"_") + "@" + "facebook.com"
      person_hash = {'uid'=>facebook_email, 'name'=>person.parsed_response['name'], 'provider' => api.category}
    elsif api.category == "google"
      person = MultiJson.decode(access_token.get("http://www.google.com/m8/feeds/contacts/default/full?max-results=1&alt=json").body)
      person_hash = google_person_hash(person,api)
    end
    return person_hash
  end

  def google_person_hash(person,api)
    email = person['feed']['id']['$t']
    name = person['feed']['author'].first['name']['$t']
    name = email if name.strip == '(unknown)'
    return {'uid' => email, 'provider' => api.category, 'name' => name }
  end

end
