class NoticeboardPostsController < ApplicationController
  layout false, :only => :show
  # GET /noticeboard_posts
  # GET /noticeboard_posts.fxml
  #skip_before_filter :require_user
  
  def index
    @noticeboard_posts = Noticeboard.find(params[:noticeboard_id]).noticeboard_posts.find(:all,:select=>"id, title, is_publish, updated_at", :order=>"updated_at DESC")

    respond_to do |format|
      format.html # 
      format.fxml  { render :fxml => @noticeboard_posts }
    end
  end

  # GET /noticeboard_posts/1
  # GET /noticeboard_posts/1.fxml
  def show
    @noticeboard_post = NoticeboardPost.find(params[:id])
    @noticeboard_posts = Noticeboard.find(params[:noticeboard_id]).noticeboard_posts.find(:all, :conditions=>"is_publish IS TRUE", :order => "updated_at DESC", :select => "id, title, is_publish, updated_at, noticeboard_id", :limit => 15)
    @noticeboard_comments = @noticeboard_post.noticeboard_comments.find(:all,:conditions => "is_publish IS TRUE", :order => "updated_at DESC")
    respond_to do |format|
      format.html #
      format.fxml  { render :fxml => @noticeboard_post }
    end
  end

  # GET /noticeboard_posts/new
  # GET /noticeboard_posts/new.fxml
  def new
    @noticeboard_post = NoticeboardPost.new

    respond_to do |format|
      format.html # new.html.erb
      format.fxml  { render :fxml => @noticeboard_post }
    end
  end

  # GET /noticeboard_posts/1/edit
  def edit
    @noticeboard_post = NoticeboardPost.find(params[:id])
  end

  # POST /noticeboard_posts
  # POST /noticeboard_posts.fxml
  def create
    params[:noticeboard_post][:noticeboard_id] = params[:noticeboard_id]
    params[:noticeboard_post][:user_id] = current_user.id
    @noticeboard_post = NoticeboardPost.new(params[:noticeboard_post])

    noticeboard = Noticeboard.find params[:noticeboard_id]
    params[:noticeboard_post][:auto_publish_comment] = noticeboard.auto_publish_comment if noticeboard


    respond_to do |format|
      if @noticeboard_post.save
        flash[:notice] = 'NoticeboardPost was successfully created.'
        format.html { redirect_to(@noticeboard_post) }
        format.fxml  { render :fxml => @noticeboard_post }
      else
        format.html { render :action => "new" }
        format.fxml  { render :fxml => @noticeboard_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /noticeboard_posts/1
  # PUT /noticeboard_posts/1.fxml
  def update
    @noticeboard_post = NoticeboardPost.find(params[:id])
    params[:noticeboard_post][:user_id] = @noticeboard_post.user_id
    params[:noticeboard_post][:noticeboard_id] = @noticeboard_post.noticeboard_id

    respond_to do |format|
      if @noticeboard_post.update_attributes(params[:noticeboard_post])
        flash[:notice] = 'NoticeboardPost was successfully updated.'
        format.html { redirect_to(@noticeboard_post) }
        format.fxml  { render :fxml => @noticeboard_post }
      else
        format.html { render :action => "edit" }
        format.fxml  { render :fxml => @noticeboard_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /noticeboard_posts/1
  # DELETE /noticeboard_posts/1.fxml
  def destroy
    @noticeboard_post = NoticeboardPost.find(params[:id])
    @noticeboard_post.destroy

    respond_to do |format|
      format.html { redirect_to(noticeboard_posts_url) }
      format.fxml  { render :fxml => @noticeboard_post }
    end
  end

end
