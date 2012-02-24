class NoticeboardCommentsController < ApplicationController
  # GET /noticeboard_comments
  # GET /noticeboard_comments.fxml
  def index
    
    #if params[:noticeboard_post_id] && params[:noticeboard_id].blank?
      noticeboard = NoticeboardPost.find(params[:noticeboard_post_id])
      @noticeboard_comments = noticeboard.blank? ? [] : noticeboard.noticeboard_comments.find(:all, :order => "updated_at DESC", :select => "id, title, is_publish, updated_at")
    #elsif params[:noticeboard_id] && params[:noticeboard_post_id]
    #  noticeboard = NoticeboardPost.find(params[:noticeboard_id])
    #  @noticeboard_comments = noticeboard.blank? ? [] : noticeboard.noticeboard_comments.find(:all, :conditions => ["noticeboard_post_id = ?", params[:noticeboard_post_id]], :order => "updated_at DESC", :select => "id, title, updated_at")
    #end
    

    respond_to do |format|
      format.html # index.html.erb
      format.fxml  { render :fxml => @noticeboard_comments }
    end
  end

  # GET /noticeboard_comments/1
  # GET /noticeboard_comments/1.fxml
  def show
    @noticeboard_comment = NoticeboardComment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.fxml  { render :fxml => @noticeboard_comment }
    end
  end

  # GET /noticeboard_comments/new
  # GET /noticeboard_comments/new.fxml
  def new
    @noticeboard_comment = NoticeboardComment.new

    respond_to do |format|
      format.html # new.html.erb
      format.fxml  { render :fxml => @noticeboard_comment }
    end
  end

  # GET /noticeboard_comments/1/edit
  def edit
    @noticeboard_comment = NoticeboardComment.find(params[:id])
  end

  # POST /noticeboard_comments
  # POST /noticeboard_comments.fxml
  def create
    params[:noticeboard_comment][:content] = params[:noticeboard_comment][:content].gsub(/\n/,"<br />")
    params[:noticeboard_comment][:user_id] = current_user.id
    @noticeboard_comment = NoticeboardComment.new(params[:noticeboard_comment])
    post = NoticeboardPost.find params[:noticeboard_comment][:noticeboard_post_id]
    if post.user_id == current_user.id
      params[:noticeboard_comment][:is_publish] = true;
    end if current_user
    respond_to do |format|
      if @noticeboard_comment.save
        flash[:notice] = 'NoticeboardComment was successfully created.'
        format.html { redirect_to noticeboard_noticeboard_post_path(params[:noticeboard_comment][:noticeboard_id],params[:noticeboard_comment][:noticeboard_post_id])}
        format.fxml  { render :fxml => @noticeboard_comment }
      else
        format.html { render :action => "new" }
        format.fxml  { render :fxml => @noticeboard_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /noticeboard_comments/1
  # PUT /noticeboard_comments/1.fxml
  def update
    @noticeboard_comment = NoticeboardComment.find(params[:id])
    params[:noticeboard_comment][:user_id] = @noticeboard_comment.user_id
    params[:noticeboard_comment][:noticeboard_id] = @noticeboard_comment.noticeboard_id
    params[:noticeboard_comment][:noticeboard_post_id] = @noticeboard_comment.noticeboard_post_id
    
    respond_to do |format|
      if @noticeboard_comment.update_attributes(params[:noticeboard_comment])
        flash[:notice] = 'NoticeboardComment was successfully updated.'
        format.html { redirect_to(@noticeboard_comment) }
        format.fxml  { render :fxml => @noticeboard_comment }
      else
        format.html { render :action => "edit" }
        format.fxml  { render :fxml => @noticeboard_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /noticeboard_comments/1
  # DELETE /noticeboard_comments/1.fxml
  def destroy
    @noticeboard_comment = NoticeboardComment.find(params[:id])
    @noticeboard_comment.destroy

    respond_to do |format|
      format.html { redirect_to(noticeboard_comments_url) }
      format.fxml  { render :fxml => @noticeboard_comment }
    end
  end
end
