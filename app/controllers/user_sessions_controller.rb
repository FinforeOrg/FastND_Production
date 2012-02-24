class UserSessionsController < ApplicationController
  skip_before_filter :require_user, :except => [:destroy]

  def new
    destroy_user_session
    @user_session = UserSession.new
  end

  def create
    destroy_user_session
    @user_session = UserSession.new(credential_information)
    respond_to do |format|
      if @user_session.save
        on_login_success(format)
      else
        format.html
        format.json { render :json => error_object(ERR_LOGIN), :status => :unprocessable_entity }
        format.xml  { render :xml  => error_object(ERR_LOGIN), :status => :unprocessable_entity }
        format.fxml { render :fxml => error_object(ERR_LOGIN), :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    user = current_user
    unless params[:column_ids].blank?
      account = User.find user.id
      account.update_attributes({:remember_columns => params[:column_ids], :is_online => false}) 
    end
    destroy_user_session
    flash[:notice] = "Logout successful!"
    respond_to do |format|
      format.xml  {head:ok}
      format.html {redirect_to new_user_session_url}
      format.fxml { render :fxml => user}
    end
  end

  def network_sign_in
    api = FeedApi.find_by_category(params[:provider].downcase)
    if api
      get_callback_network
      session['social_login'] ||= {}
      unless api.isFacebook?
        request_token = get_request_token(api)
        login_option = api.category != "google" ? {:force_login => 'false'} : {}
        auth_url = request_token.authorize_url(login_option)
        session['social_login'][@cat] = {:format=>params[:format], :rt=>request_token.token, :rs=>request_token.secret, :category=>api.category, :callback=>params[:callback]}
      else
        auth_url = FGraph.oauth_authorize_url(api.api,@callback_url)
        session['social_login'][@cat] = {:format=>params[:format], :rt=>'', :rs=>'',:category=>api.category,:callback=>params[:callback]}
      end
    end
    params[:format] = "html"
    respond_to do |format|
      if auth_url.blank?
        #respond_to_do(format, {:respond => get_failed_message})
        format.html {render :text=> get_failed_message}
      else
        format.html {redirect_to auth_url}
      end
    end

    rescue => e
      accident_alert(e.to_s)
  end

  def create_network
    destroy_user_session
    includes = []
    if !params[:cat].blank? && !session['social_login'].blank?
      @cat = params[:cat]
      stored_data = session['social_login'][@cat]
      if !stored_data.blank?
        api = FeedApi.find_by_category(stored_data[:category])

        unless api.isFacebook?
          request_token = OAuth::RequestToken.new(get_consumer(api),stored_data[:rt],stored_data[:rs])
          access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
        else
          get_callback_network
          access_token = FGraph.oauth_access_token(api.api, api.secret, {:code=>params[:code],:redirect_uri=>@callback_url})
        end

        profile = get_profile_network(access_token,api,stored_data)
        user_access_token = AccessToken.find_by_uid(profile['uid'])
        user_access_token = create_or_update_user_access_token(profile,access_token,user_access_token)

        if user_access_token.user.blank?
          random_chars = get_random_token
	  email_fake = get_random_token + "@#{user_access_token.category}.com"
          user = User.create({:full_name=> profile['name'], 
			    :oauth_token=> user_access_token.token,
			    :email_work => email_fake,
			    :login=> email_fake,
			    :password=>random_chars,
			    :password_confirmation=>random_chars})
        else
          user = user_access_token.user
        end

        user_access_token.user_id = user.id
        user_access_token.save(false)
        session['social_login'][@cat] = nil if user && user_access_token
        params[:auth_token] = user.single_access_token
        params[:format] = stored_data[:format] if stored_data[:callback].blank?
        current_user
      end
    end

    respond_to do |format|
      if user.blank?
        accident_alert("InvalidCookiesOrSession")
      elsif stored_data[:callback].blank?
        create_column_backgroundly(user_access_token)
        respond_to_do(format, user)
      else
        param_auth = "auth_token=#{user.single_access_token}" + (user.profiles.length < 1 ? "&update_profile=true" : "&update_profile=false")
        redirect_uri = stored_data[:callback] + ((stored_data[:callback].scan(/\?/i).size > 0) ? "&" : "?") + param_auth
        create_column_backgroundly(user_access_token)
        format.html {redirect_to redirect_uri}
      end
    end

    #rescue => e
    #  accident_alert(e.to_s)

  end

  def public_login
    pids =  params[:pids].gsub(/\,$|^\,|\s/i,"").split(",").collect{|i| i.to_i}
    @user_session = nil
    user = User.find_public_profile(pids)
    
    if user
    	destroy_user_session
    	@user_session = UserSession.create!(user)
    end

    respond_to do |format|
      if @user_session.blank?
        respond_to_do(format, {:message=>"NotFound"})
      else
        profile_exceptions = @user_session.record.profiles.select{|p| pids.include?(p.id)}
        profile_objects = profile_exceptions.map{|pr| pr.attributes.merge({:profile_category=>pr.profile_category.attributes})}
        results = {:user=>user.attributes.merge({:profiles=>profile_objects})}
        format.html #{redirect_to users_path}
        format.json { render :json => results }
        format.xml  { render :xml => results }
        format.fxml { render :fxml =>results}
      end
    end

   # rescue => e
   #   accident_alert(e.to_s)
  end

  def failure_network
    params[:message] ||= ERR_LOGIN
    respond_to do |format|
      format.json { render :json => error_object(params[:message]), :status => :unprocessable_entity }
      format.xml  { render :xml  => error_object(params[:message]), :status => :unprocessable_entity }
      format.fxml { render :fxml => error_object(params[:message]), :status => :unprocessable_entity }
    end
  end

  def destroy
    @authorization = current_user.authorizations.find(params[:id])
    flash[:notice] = "Successfully deleted #{@authorization.provider} authentication."
    @authorization.destroy
    redirect_to root_url
  end

  def generate_captcha
    respond_to do |format|
      format.html {render :layout => false}
    end
  end

  def new_worker
    system "/usr/bin/rake resque:work QUEUE=EmailAlert,TwitterUtils RAILS_ENV=production &"
    render :text=> "1 New Wroker added"
  end


  private

  def create_or_update_user_access_token(profile,access_token,user_access_token)
    user_access_token = user_access_token ? user_access_token : AccessToken.new()
    user_access_token.category = profile['provider']
    user_access_token.token = profile['provider'] != "facebook" ? access_token.token : access_token['access_token']
    user_access_token.secret = profile['provider'] != "facebook" ? access_token.secret : ''
    user_access_token.uid = profile['uid']
    user_access_token
  end

  def destroy_user_session
    current_user_session.destroy unless current_user_session.blank?
    session[:token] = nil
    session[:users_email] = nil
    session[:asecret] = nil
    session[:atoken] = nil
    session[:rtoken_linkedin] = nil
    session[:rsecret_linkedin] = nil
  end

  def credential_information
    params[:user_session] = {:login => params[:login], :password => params[:password]} if params[:user_session].blank?
    return params[:user_session]
  end

  def on_login_success(format)
    all_includes = {:profiles =>{:only=>[:id,:title],:include=>{:profile_category=>{:only=>[:id,:title]}}}}
    format.html #{redirect_to users_path}
    format.json { render :json => @user_session.record.to_json(:include=>all_includes) }
    format.xml  { render :xml => @user_session.record.to_xml(:include=>all_includes)  }
    format.fxml { render :fxml => @user_session.record } #TODO : make it tobe available for includes
  end

  def create_column_backgroundly(access_token)
    feed_token = FeedToken.find_by_uid(access_token.uid)
    title = access_token.category
    account = access_token.uid
    google_columns = %w(portfolio gmail)
    accounts = []
    if feed_token.blank?
      if access_token.category != "google"
        accounts << FeedAccount.create({:category=>access_token.category, :account => account, :name => title,:user_id => access_token.user_id, :window_type => "tab"})
      else
        google_columns.each do |category|
          accounts << FeedAccount.create({:category=>category, :account => account, :name => title,:user_id => access_token.user_id, :window_type => "tab"})
        end
      end
      accounts.each do |fa|
        feed_token = FeedToken.create({:user_id => access_token.user_id,:feed_account_id => fa.id, :token => access_token.token, :secret => access_token.secret,:uid=>access_token.uid})
      end
    elsif access_token.category != "google"
        feed_token.update_attributes({:token => access_token.token, :secret => access_token.secret, :token_preauth => "", :secret_preauth => "", :url_oauth => ""})
    else
      tokens = FeedToken.find_all_by_uid(access_token.uid)
      tokens.each do |token|
        account = token.feed_account
        if google_columns.include?(account.category) && token.user_id == access_token.user_id
          token.update_attributes({:token => access_token.token, :secret => access_token.secret, :token_preauth => "", :secret_preauth => "", :url_oauth => ""})
        end
      end
    end
  end

  def get_callback_network
    @cat = get_random_token if @cat.blank?
    @callback_url = "http://#{request.host}/auth/#{params[:provider]}/callback?cat=#{@cat}"
  end

end
