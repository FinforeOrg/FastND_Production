class UserFeedsController < ApplicationController
  
  def index
    if current_user
      @user_feeds = params[:feed_account_id].blank? ? current_user.user_feeds : UserFeed.find_all_by_feed_account_id_and_user_id(params[:feed_account_id],current_user.id)
    else
      @user_feeds = []
    end
    
    respond_to do |format|
      respond_to_do(format,@user_feeds,{:feed_info=>{:except=>[:created_at,:updated_at]}})
    end
  end

  def create
    feeds_params = params[:user_feed]
    arrName = feeds_params[:name].split("::")
    user = current_user ? User.find(feeds_params[:user_id]) : current_user
    
    if !params[:feed_account_id].blank? && feeds_params[:feed_account_id].blank?
      feeds_params[:feed_account_id] = params[:feed_account_id]
    end
    
    @feed_account = user.feed_accounts.find(feeds_params[:feed_account_id])
    feed_category = @feed_account.isTwitter? ? "twitter" : @feed_account.category
    new_followers = []

    if @feed_account
      if(arrName.size > 0)
        arrName.each do |address|
          user_feed = UserFeed.find_by_name_and_feed_account_id(address,@feed_account.id)
          unless user_feed
            @user_feed = user_feed_creation(address, feed_category, user.id, @feed_account.id)
	    new_followers.push(address) if @feed_account.isFollowable?
          end
        end
      else
        unless UserFeed.find_by_name_and_feed_account_id(feeds_params[:name],@feed_account.id)
          @user_feed = user_feed_creation(feeds_params[:name], feed_category, user.id, @feed_account.id)
	  new_followers.push(feeds_params[:name]) if @feed_account.isFollowable?
        end
      end  
      Resque.enqueue(Finfores::Backgrounds::TwitterUtils,'follow',@feed_account.id, new_followers.to_yaml) if new_followers.size > 0
      #Finfores::Jobs::TwitterWorker.new('follow',@feed_account.id, new_followers.to_yaml) if new_followers.size > 0
    end

    respond_to do |format|
      if @user_feed
        flash[:notice] = 'user_feed was successfully created.'
        includes = params[:dependency].blank? ? {:feed_account=>{:except=>[:created_at,:updated_at]},:feed_info=>{:except=>[:created_at,:updated_at]}} : []
        respond_to_do(format, @user_feed, includes)
      else
        respond_error_to_do(format, @user_feed,"new")
      end
    end
    
    rescue => e
      LoggedException.create_from_exception(self,e,'')
      respond_to do |format|
        respond_to_do(format, @user_feed, [:feed_account])
      end
  end

  def update
    @user_feed = UserFeed.find(params[:id])
    @saved = @user_feed.update_attributes(params[:user_feed])

    respond_to do |format|
      if @saved
        flash[:notice] = 'user_feed was successfully updated.'
        includes = params[:dependency].blank? ? {:feed_account=>{:except=>[:created_at,:updated_at]},:feed_info=>{:except=>[:created_at,:updated_at]}} : []
        respond_to_do(format, @user_feed, includes)
      else
        respond_error_to_do(format, @user_feed,"edit")
      end
    end
  end

  def destroy
    @user_feed = UserFeed.find(params[:id])
    if @user_feed
      @user_feed.destroy
      Resque.enqueue(Finfores::Backgrounds::TwitterUtils,'unfollow', @user_feed.feed_account.id, [@user_feed.name].to_yaml)
      #Finfores::Jobs::TwitterWorker.new('unfollow', @user_feed.feed_account.id, [@user_feed.name].to_yaml)
    end
    respond_to do |format|
      respond_to_do(format, @user_feed)
    end
  end

  private
    def check_array_type(array_types,user)
      arr_rss = []
      for i in 0..(array_types.size-1) do
        arr_rss << array_types[i] if array_types[i] == "rss"
      end
      if arr_rss.size == array_types.size
        user_rss = user.user_feeds.find_all_by_category_type("rss")
        user_rss.each{|rss| rss.destroy} if user_rss.size > 0
      end
    end

    def user_feed_creation(name, category, user_id, feed_account_id)
      name = name.gsub(/^(\|\|)|(\|\|$)/i,"")
      array_name = name.split("||")
      info_address = (array_name.size > 0) ? array_name[1] : array_name[0]
      info_title = (array_name.size >0 ) ? array_name[0] : ""
      feed_info = create_or_update_feed_info(info_title, info_address, category.ucfirst)
      return create_user_feed(feed_account_id, info_address, feed_info.id, info_title)
    end
end
