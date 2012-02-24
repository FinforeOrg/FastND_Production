class NoticeboardUsersController < ApplicationController
  # GET /noticeboard_users
  # GET /noticeboard_users.fxml
  def index
    if !params[:noticeboard_id].blank? && params[:noticeboard_id] != "null" && params[:noticeboard_id] != "0"
      @noticeboard_users = Noticeboard.find(params[:noticeboard_id]).noticeboard_users
    else
      @noticeboard_users = NoticeboardUser.find(:all, :conditions => ["user_id = ?",current_user.id])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.fxml  { render :fxml => @noticeboard_users.to_fxml(:include => [:user, :noticeboard]) }
    end
  end

  # GET /noticeboard_users/1
  # GET /noticeboard_users/1.fxml
  def show
    #if params[:noticeboard_id]
    #  @noticeboard_user = NoticeboardUser.find_by_noticeboard_id_and_user_id(params[:noticeboard_id], current_user.id)
    #else
      @noticeboard_user = NoticeboardUser.find(params[:id])
    #end

    respond_to do |format|
      format.html # show.html.erb
      format.fxml  { render :fxml => @noticeboard_user }
    end
  end

  # GET /noticeboard_users/new
  # GET /noticeboard_users/new.fxml
  def new
    @noticeboard_user = NoticeboardUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.fxml  { render :fxml => @noticeboard_user }
    end
  end

  # GET /noticeboard_users/1/edit
  def edit
    @noticeboard_user = NoticeboardUser.find(params[:id])
  end

  # POST /noticeboard_users
  # POST /noticeboard_users.fxml
  def create
    unless params[:email].blank?
      user = User.find :first, :conditions => ["email_home LIKE ? OR email_work LIKE ?", params[:email], params[:email]]
      params[:noticeboard_user][:user_id] = user.id if user
    end
    
    params[:noticeboard_user][:user_id] = current_user.id if params[:noticeboard_user][:user_id].blank? && current_user
    
    if params[:noticeboard_user][:noticeboard_id].to_i < 1 && !params[:noticeboard_id] .blank?
      params[:noticeboard_user][:noticeboard_id] = params[:noticeboard_id] 
    end
    
    @noticeboard_user = NoticeboardUser.find_by_user_id_and_noticeboard_id(params[:noticeboard_user][:user_id], params[:noticeboard_user][:noticeboard_id])

    if @noticeboard_user
      if @noticeboard_user.is_user_remove
        @noticeboard_user.update_attribute(:is_user_remove, false)
        @noticeboard_user.reload
      end
    else
      @noticeboard_user = NoticeboardUser.create(params[:noticeboard_user])
    end
    

    respond_to do |format|
      if @noticeboard_user
        flash[:notice] = 'NoticeboardUser was successfully created.'
        format.html { redirect_to(@noticeboard_user) }
        format.fxml  { render :fxml => @noticeboard_user.to_fxml(:include => [:user, :noticeboard]) }
      else
        format.html { render :action => "new" }
        format.fxml  { render :fxml => @noticeboard_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /noticeboard_users/1
  # PUT /noticeboard_users/1.fxml
  def update
    unless params[:email].blank?
      user = User.find :first, :conditions => ["email_home LIKE ? OR email_work LIKE ?", params[:email], params[:email]]
      params[:noticeboard_user][:user_id] = user.id if user
    end
    
    if params[:noticeboard_user][:user_id].blank? && current_user
      params[:noticeboard_user][:user_id] = current_user.id
    end
    
    @noticeboard_user = NoticeboardUser.find(params[:id])
    
    respond_to do |format|
      if @noticeboard_user.update_attributes(params[:noticeboard_user])
        flash[:notice] = 'NoticeboardUser was successfully updated.'
        format.html { redirect_to(@noticeboard_user) }
        format.fxml  { render :fxml => @noticeboard_user.to_fxml(:include => [:user, :noticeboard]) }
      else
        format.html { render :action => "edit" }
        format.fxml  { render :fxml => @noticeboard_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /noticeboard_users/1
  # DELETE /noticeboard_users/1.fxml
  def destroy
    @noticeboard_user = NoticeboardUser.find(params[:id])
    @noticeboard_user.destroy

    respond_to do |format|
      format.html { redirect_to(noticeboard_users_url) }
      format.fxml  { render :fxml => @noticeboard_user }
    end
  end

  def check_user
    board_user = NoticeboardUser.find_by_noticeboard_id_and_user_id(params[:noticeboard_id],current_user.id)
    error_message = "<error>You are not registered for this internal noticeboard</error>",
    respond_to do |format|
      if board_user
        format.xml {render :xml => board_user, :head => :ok}
      else
        format.xml {render :xml => error_message, :status => :unprocessable_entity}
      end
    end
  end
  

end
