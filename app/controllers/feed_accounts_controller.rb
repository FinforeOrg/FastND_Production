class FeedAccountsController < ApplicationController
  skip_before_filter :require_user, :only=>[:column_auth,:column_callback]
  before_filter :prepare_dependency, :only=>[:index,:create,:update]

  def index
    if !current_user.has_columns? && params[:auto_populate]
      start_autopopulate
    elsif params[:ids]
      FeedAccount.clear_columns_by_ids(params[:ids])
    end
    @feed_accounts = current_user.feed_accounts
    sort_columns_by_remembering

    respond_to do |format|
      #respond_to_do(format, @feed_accounts, [:user_feeds, :keyword_column, :feed_token])
       respond_to_do(format, @feed_accounts, @default_dependency)
    end
  end

  def column_auth
    api = FeedApi.send(params[:provider].downcase)
    tmp_callback = params[:callback]
    params[:callback] = nil

    if api
      get_callback

      unless api.isFacebook?
        request_token = get_request_token(api)
        auth_url = request_token.authorize_url
	session[@cat] = {:format => params[:format], :category  => api.category, :callback  => tmp_callback, :column_id => params[:feed_account_id], :rt => request_token.token, :rs => request_token.secret}
      else
        auth_url = FGraph.oauth_authorize_url(api.api, @callback_url)
        session[@cat] = {:format => params[:format], :category  => api.category, :callback  => tmp_callback, :column_id => params[:feed_account_id], :rt => '', :rs => ''}
      end
    end

    params[:format] = "html"

    respond_to do |format|
      if auth_url.blank?
        respond_to_do(format, {:respond => get_failed_message})
      else
        format.html {redirect_to auth_url}
      end
    end

    rescue => e
      accident_alert(e.to_s)
  end

  def column_callback
    feed_account = {}
    includes = []
    @cat = params[:cat]

    if !@cat.blank? && !session[@cat].blank?
      stored_data = session[@cat]
      user = User.find_by_single_access_token(params[:finfore_token],:select=>'id,single_access_token') unless params[:finfore_token].blank?
      api = FeedApi.send(stored_data[:category])

      unless api.isFacebook?
        request_token = OAuth::RequestToken.new(get_consumer(api),stored_data[:rt],stored_data[:rs])
        access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
        includes.push(:feed_token)
      else
        get_callback
        access_token = FGraph.oauth_access_token(api.api, api.secret, {:code=>params[:code],:redirect_uri=>@callback_url})
      end
      feed_account = create_column_and_token(access_token,api,stored_data,user)
    end

     if !stored_data.blank?
       params[:format] = stored_data[:format] if stored_data[:callback].blank?
       respond_to do |format|
  	 if stored_data[:callback].blank?
	   respond_to_do(format, feed_account, includes)
	 else
	   param_auth = "auth_token=#{user.single_access_token}" + (feed_account.blank? ? "" : "&feed_account_id=#{feed_account.id}&feed_token_id=#{feed_account.feed_token.id}")
	   redirect_custom = stored_data[:callback] + ((stored_data[:callback].scan(/\?/i).size > 0) ? "&" : "?") + param_auth
	   format.html {redirect_to redirect_custom}
	 end
        end
        #session[@cat] = nil if !session[@cat].blank?
     else
       accident_alert("SessionNotFound")
     end
    
  end
  
  def create
    feed_acct = params[:feed_account]

    if !feed_acct[:account].blank? && feed_acct[:account].split("::").length > 1 && feed_acct[:account].index('::').nil?
      arr_acct = feed_acct[:account].blank? ? [] : feed_acct[:account].split("::")
      update_all_blank = false
      _accounts = feed_acct[:account]

      arr_catg  = feed_acct[:category].split("::")
      arr_namee = feed_acct[:name].split("::")
      arr_window  = feed_acct[:window_type].split("::")
      acct_password = feed_acct[:password].blank? ? '' : Base64.encode64(feed_acct[:password])
      param_account_default = {:user_id  => current_user.id, :password => acct_password}
      for i in 0..(arr_acct.size-1) do
        win_type = feed_acct[:window_type].blank? ? 'window' : '';
        win_type = (arr_window.size != arr_acct.size) ? win_type : arr_window[i];
	param_account = param_account_default.merge({:name => arr_namee[i],:account => arr_acct[i],:category => arr_catg[i],:window_type => win_type})
        @feed_account = FeedAccount.create(param_account)
      end
    else
      feed_acct[:account] = feed_acct[:category] if feed_acct[:account].blank?
      feed_acct[:password] = feed_acct[:password].blank? ? '' : Base64.encode64(feed_acct[:password])
      feed_acct[:user_id]  = current_user.id
      win_type = feed_acct[:window_type].blank? ? 'window' : '';
      @feed_account = FeedAccount.create(feed_acct)
    end
    
    respond_to do |format|
      if @feed_account.errors.length < 1
        create_linkedin_preauth if @feed_account.isLinkedin?
        includes = params[:dependency].blank? ? @default_dependency : []
        respond_to_do(format,@feed_account, includes)
      else
        respond_error_to_do(format,@feed_account,"new")
      end
    end
  end

  def update
    @feed_account = FeedAccount.find(params[:id])
    unless params[:feed_account][:password].blank?
      params[:feed_account][:password] = Base64.encode64(params[:feed_account][:password])
    end
    @saved = @feed_account.update_attributes(params[:feed_account])

    respond_to do |format|
      if @saved
        includes = params[:dependency].blank? ? @default_dependency : []
        respond_to_do(format,@feed_account, includes)
      else
        respond_error_to_do(format, @feed_account,"edit")
      end
    end
  end

  def destroy
    @feed_account = FeedAccount.find(params[:id])
    @feed_account.destroy

    respond_to do |format|
      format.html { redirect_to(feed_accounts_url) }
      format.xml  { render :xml => @feed_account, :status => 200 }
      format.json  { render :json => @feed_account, :status => 200 }
      format.fxml  { render :fxml => @feed_account }
    end
  end

  private
    def create_linkedin_preauth
      callback_url = "http://#{request.host_with_port}/feed_tokens/linkedin_callback"
      feed_api = FeedApi.linkedin
      client = LinkedIn::Client.new(feed_api.api, feed_api.secret)
      request_token = client.request_token(:oauth_callback => callback_url)
      obj = {:token_preauth   => request_token.token,
             :secret_preauth  => request_token.secret,
             :feed_account_id => @feed_account.id,
             :url_oauth       => client.request_token.authorize_url}
      FeedToken.create(obj)
    end

    def sort_columns_by_remembering
      portfolios = @feed_accounts.select{|account| account.isPortfolio? }
      non_portfolios = @feed_accounts.select{|account| !account.isPortfolio? }

      unless current_user.remember_columns.blank?
        tmpArr = []
        current_user.remember_columns.split("|").each do |key|
          non_portfolios.each do |yek|
            if key == yek.id.to_s
              tmpArr.push(yek)
              break
            end
          end
        end

        if tmpArr.size < non_portfolios.size
          miss_accounts = non_portfolios - tmpArr
          non_portfolios = tmpArr + miss_accounts
        else
          non_portfolios = tmpArr
        end
      end
      @feed_accounts = non_portfolios + portfolios
    end

    def create_column_and_token(access_token,api,stored_data,user)
      profile = get_profile_network(access_token,api,stored_data)
      acct = nil

      if stored_data[:category].match(/google/) && stored_data[:column_id].blank?
        categories = ["gmail","portfolio"]
      elsif !stored_data[:column_id].blank?
        acct = FeedAccount.find(stored_data[:column_id])
        categories = [acct.category]
      else
        categories = [stored_data[:category]]
      end


      categories.each do |category|
        account_data = {:account  => profile['uid'], :category => category, :user_id => user.id}
        if stored_data[:column_id].blank?
          account_data.merge!({:name => (category != "linkedin" ? profile['uid'] : profile['name']),:window_type => 'tab' })
          acct = FeedAccount.create(account_data)
        else
          acct.update_attributes(account_data) if acct
        end

        if acct
          token_data = {:user_id => user.id, :feed_account_id => acct.id,
                      :token  => (category == "facebook" ? access_token['access_token'] : access_token.token),
                      :secret => (category == "facebook" ? '' : access_token.secret)}
          if stored_data[:column_id].blank? || acct.feed_token.blank?
            ft = FeedToken.create(token_data)
          else
            ft = acct.feed_token
            ft = ft.update_attributes(token_data)
          end
        end
      end
      return acct
    end

    def prepare_dependency
      no_stamp = [:updated_at,:created_at]
      @default_dependency = {:user_feeds => {:include=>{:feed_info=>{:only=>[:id,:follower,:title]}},:except=>no_stamp},
	  	             :keyword_column => {:except=>no_stamp},
                             :feed_token     =>{:except=>no_stamp}
                            }
    end
end
