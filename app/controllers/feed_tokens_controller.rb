class FeedTokensController < ApplicationController
  skip_before_filter :require_user #, :only=> :callback
  before_filter :prepare_oauth, :only=> :create
  before_filter :make_api
  # GET /feed_tokens
  # GET /feed_tokens.xml
  def index
    if current_user
      tokens = current_user.feed_tokens
      tokens.each do |ftoken|
        if ftoken.updated_at <= 10.minutes.ago && ftoken.token.blank? && ftoken.secret.blank?
          create_linkedin_preauth(ftoken) if ftoken.feed_account.category == 'linkedin'
        end
       end
      end
    
    @feed_tokens = current_user ? current_user.feed_tokens : FeedToken.all

    respond_to do |format|
      respond_to_do(format,@feed_tokens)
    end
  end

  # GET /feed_tokens/1
  # GET /feed_tokens/1.xml
  def show
    @feed_token = FeedToken.find(params[:id])

    respond_to do |format|
      respond_to_do(format,@feed_token)
    end
  end

  # GET /feed_tokens/new
  # GET /feed_tokens/new.xml
  def new
    @feed_token = FeedToken.new

    respond_to do |format|
      respond_to_do(format,@feed_token)
    end
  end

  # GET /feed_tokens/1/edit
  def edit
    @feed_token = FeedToken.find(params[:id])
  end

  # POST /feed_tokens
  # POST /feed_tokens.xml
  def create
    account = FeedAccount.find params[:feed_token][:feed_account_id]
    @feed_token = account.feed_token ? account.feed_token : FeedToken.new(params[:feed_token])

    respond_to do |format|
      if @feed_token.save
        if @feed_token.user_id.blank? && @feed_token.feed_account_id.blank?
          @feed_token.destroy
        end
        respond_to_do(format,@feed_token)
      else
        respond_error_to_do(format,@feed_token,"new")
      end
    end
  end

  # PUT /feed_tokens/1
  # PUT /feed_tokens/1.xml
  def update
    unless params[:feed_token].blank?
       params[:id] =  params[:feed_token][:id] unless  params[:feed_token][:id].blank?
       params[:oauth_verifier] = params[:feed_token][:oauth_verifier] unless params[:feed_token][:oauth_verifier].blank?
    end
    @feed_token = FeedToken.find(params[:id])
    feed_api = FeedApi.find_by_category(@feed_token.feed_account.category)
    
    if @feed_token.feed_account.category == "linkedin"
      client = LinkedIn::Client.new(feed_api.api, feed_api.secret)
      atoken, asecret = client.authorize_from_request(@feed_token.token_preauth, @feed_token.secret_preauth, params[:oauth_verifier])
    elsif @feed_token.feed_account.category == "twitter"
      client = TwitterOAuth::Client.new(:consumer_key => feed_api.api,
                                        :consumer_secret => feed_api.secret )
      access_token = client.authorize(@feed_token.token_preauth, @feed_token.secret_preauth, :oauth_verifier => params[:oauth_verifier])
      atoken = access_token.token
      asecret = access_token.secret
    end
          
      params[:feed_token][:token] = atoken
      params[:feed_token][:secret] = asecret
      params[:feed_token][:token_preauth] = ''
      params[:feed_token][:secret_preauth] = ''
      params[:feed_token][:url_oauth] = ''
      
    respond_to do |format|
      if @feed_token.update_attributes(params[:feed_token])
        respond_to_do(format,@feed_token)
      else
        respond_error_to_do(format,@feed_token,"edit")
      end
    end
  end

  # DELETE /feed_tokens/1
  # DELETE /feed_tokens/1.xml
  def destroy
    @feed_token = FeedToken.find(params[:id])
    @feed_token.destroy

    respond_to do |format|
      respond_to_do(format,@feed_token)
    end
  end

  def linkedin_callback  
    feed_token = FeedToken.find_by_token_preauth(params[:oauth_token])

    unless params[:oauth_verifier].blank?
      @client = LinkedIn::Client.new(@linkedin_api, @linkedin_secret)

      atoken, asecret = @client.authorize_from_request(feed_token.token_preauth, feed_token.secret_preauth, params[:oauth_verifier])
      
      feed_token.update_attributes({:token => atoken,:secret=>asecret})

      session[:atoken] = atoken
      session[:asecret] = asecret
    else
      session[:atoken] = feed_token.token
      session[:asecret] = feed_token.secret
    end

  rescue => e
    
  end
  
  def twitter_callback
    #nothing todo here because the atoken and asecret is received in desktop application
    if params[:feed_account_id]
      feed_token = FeedToken.find_by_feed_account_id(params[:feed_account_id])
      feed_api = FeedApi.find_by_category(feed_token.feed_account.category)
      client = TwitterOAuth::Client.new(:consumer_key => feed_api.api, :consumer_secret => feed_api.secret)
      access_token = client.authorize(feed_token.token_preauth, feed_token.secret_preauth, :oauth_verifier => params[:oauth_verifier])
      if client.authorized?
        feed_token.update_attributes({:token_preauth => '', :secret_preauth => '', :url_oauth=>'', :token => access_token.token, :secret=> access_token.secret})
      end
    end
  end

  def google_callback
  end

  private
  def prepare_oauth
    @feed_account = FeedAccount.find(params[:feed_token][:feed_account_id])
    if @feed_account.category == "linkedin"
      prepare_oauth_linkedin
    elsif @feed_account.category == "twitter"
      prepare_oauth_twitter
    end
  end

  def prepare_oauth_twitter
    feed_api = FeedApi.find_by_category(@feed_account.category)
    client_options = {:site => 'https://api.twitter.com',:authorize_path => '/oauth/authenticate'}
    feed_api = FeedApi.create({:api=>@twitter_api, :secret=>@twitter_secret, :category=>"twitter"}) unless feed_api
    params[:callback] = default_twitter_callback if params[:callback].blank?

    consumer = OAuth::Consumer.new(feed_api.api, feed_api.secret, client_options)
    request_token = consumer.get_request_token(:oauth_callback => params[:callback])
    
    rtoken  = request_token.token
    rsecret = request_token.secret
    params[:feed_token][:url_oauth] = request_token.authorize_url
    params[:feed_token][:token_preauth] = request_token.token
    params[:feed_token][:secret_preauth] = request_token.secret
  end
  
  def prepare_oauth_linkedin
    if params[:callback].blank?
      @linkedin_callback = "http://#{request.host_with_port}/feed_tokens/linkedin_callback"
    else
      @linkedin_callback = params[:callback]
    end

    feed_api = FeedApi.find_by_category(@feed_account.category)
    client = LinkedIn::Client.new(feed_api.api, feed_api.secret)
    request_token = client.request_token(:oauth_callback => @linkedin_callback)
    rtoken  = request_token.token
    rsecret = request_token.secret
    params[:feed_token][:url_oauth] = client.request_token.authorize_url
    params[:feed_token][:token_preauth]  = request_token.token
    params[:feed_token][:secret_preauth] = request_token.secret
  end
  
  def create_linkedin_preauth(feed_token)
    callback_url = "http://#{request.host_with_port}/feed_tokens/linkedin_callback"
    feed_api = FeedApi.find_by_category("linkedin")
    client = LinkedIn::Client.new(feed_api.api, feed_api.secret)
    request_token = client.request_token(:oauth_callback => callback_url)
    obj = {:token_preauth    => request_token.token, 
           :secret_preauth   => request_token.secret,
           :url_oauth        => client.request_token.authorize_url,
          }
    feed_token.update_attributes(obj)      
  end

  def make_api
    @linkedin_api = 't_4wFj-MqkExvbTSoRGButHzVA44kwnsaJnswD63RCHeWet7B4N9REyo6pMtztA5'
    @linkedin_secret = 'TPHkKZdW_Wt1Mc_TScbj9e5eSzHHs62ERCDB1kVTKXlQwivapUaOP0Tw_1NcGOq9'
    @twitter_api = 'RhXx78t99jxXAf44NwY4w'
    @twitter_secret = 'ty0AhbgCaDQULguJTQlCBgEO8vi4i4ZtPMR2LEM2KM'
  end

  def default_twitter_callback
    "http://#{request.host_with_port}/feed_tokens/twitter_callback?feed_account_id=#{params[:feed_token][:feed_account_id]}"
  end

end
