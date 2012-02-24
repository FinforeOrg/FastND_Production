class NoticeboardsController < ApplicationController
  # GET /noticeboards
  # GET /noticeboards.xml
  def index
    @noticeboards = Noticeboard.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @noticeboards }
      format.fxml  { render :fxml => @noticeboards }
    end
  end

  # GET /noticeboards/1
  # GET /noticeboards/1.xml
  def show
    @noticeboard = Noticeboard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @noticeboard }
      format.fxml  { render :fxml => @noticeboard }
    end
  end

  # GET /noticeboards/new
  # GET /noticeboards/new.xml
  def new
    @noticeboard = Noticeboard.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @noticeboard }
      format.fxml  { render :fxml => @noticeboard }
    end
  end

  # GET /noticeboards/1/edit
  def edit
    @noticeboard = Noticeboard.find(params[:id])
  end

  # POST /noticeboards
  # POST /noticeboards.xml
  def create
    @noticeboard = Noticeboard.new(params[:noticeboard])

    respond_to do |format|
      if @noticeboard.save
        flash[:notice] = 'Noticeboard was successfully created.'
        format.html { redirect_to(@noticeboard) }
        format.xml  { render :xml => @noticeboard, :status => :created, :location => @noticeboard }
        format.fxml  { render :fxml => @noticeboard}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @noticeboard.errors, :status => :unprocessable_entity }
        format.fxml  { render :fxml => @noticeboard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /noticeboards/1
  # PUT /noticeboards/1.xml
  def update
    @noticeboard = Noticeboard.find(params[:id])

    respond_to do |format|
      if @noticeboard.update_attributes(params[:noticeboard])
        flash[:notice] = 'Noticeboard was successfully updated.'
        format.html { redirect_to(@noticeboard) }
        format.xml  { head :ok }
        format.fxml  { render :fxml => @noticeboard}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @noticeboard.errors, :status => :unprocessable_entity }
        format.fxml  { render :fxml => @noticeboard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /noticeboards/1
  # DELETE /noticeboards/1.xml
  def destroy
    @noticeboard = Noticeboard.find(params[:id])
    @noticeboard.destroy

    respond_to do |format|
      format.html { redirect_to(noticeboards_url) }
      format.xml  { head :ok }
      format.fxml  { render :fxml => @noticeboard}
    end
  end

  def rss
    @noticeboard = Noticeboard.find(params[:id])
    noticeboard_user = @noticeboard.noticeboard_users.find_by_user_id(current_user.id) if @noticeboard
    if noticeboard_user && noticeboard_user.is_active && !noticeboard_user.is_user_remove
      @articles = @noticeboard.noticeboard_posts.find(:all, :order => "updated_at DESC", :limit => 25, :conditions => "is_publish IS TRUE")
    else
      @articles = []
    end
    render :layout => false
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end
  
  def check_updates
    user_roles = NoticeboardRoleUser.find_all_by_user_id(current_user.id)
    duration = 1500
    
    user_roles.each do |user_role|
      noticeboard_user = user_role.noticeboard.noticeboard_users.count(:all, :conditions => ["user_id = ? AND is_active IS true AND is_user_remove IS false", current_user.id])
      
      if noticeboard_user.to_i > 0
        
        new_users = NoticeboardUser.count(:all, :conditions => ["noticeboard_id = ? AND is_active IS false AND is_user_remove IS FALSE", user_role.noticeboard_id])
        if new_users > 0
          @item_message = <<-EOF
            <item>
              <message>#{new_users} new users in noticeboard  #{user_role.noticeboard.name}.</message>
              <duration>#{duration}</duration>
            </item>
          EOF
          duration = duration*2
        end
        
        new_post = user_role.noticeboard.noticeboard_posts.count(:all, :conditions => "is_publish IS FALSE")
        
        if new_post > 0
          @item_message = <<-EOF
            <item>
              <message>#{new_post} new postings in noticeboard #{user_role.noticeboard.name}.</message>
              <duration>#{duration}</duration>
            </item>
          EOF
          duration = duration*2
        end
        
        new_comment = user_role.noticeboard.noticeboard_comments.count(:all, :conditions => "is_publish IS FALSE")
        
        if new_comment > 0
          @item_message = <<-EOF
            <item>
              <message>#{new_comment} new comments in noticeboard #{user_role.noticeboard.name}.</message>
              <duration>#{duration}</duration>
            </item>
          EOF
          duration = duration*2
        end
        
      end      
    end
    
    render :layout => false
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
    
  end


end
