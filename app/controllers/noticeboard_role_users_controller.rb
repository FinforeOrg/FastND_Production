class NoticeboardRoleUsersController < ApplicationController
  # GET /noticeboard_role_users
  # GET /noticeboard_role_users.fxml
  def index
    @noticeboard_role_users = current_user.noticeboard_role_users
    respond_to do |format|
      format.html # index.html.erb
      format.fxml  { render :fxml => @noticeboard_role_users.to_fxml(:include=>[:noticeboard,:noticeboard_role]) }
    end
  end

  # GET /noticeboard_role_users/1
  # GET /noticeboard_role_users/1.fxml
  def show
    @noticeboard_role_user = NoticeboardRoleUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.fxml  { render :fxml => @noticeboard_role_user }
    end
  end

  # GET /noticeboard_role_users/new
  # GET /noticeboard_role_users/new.fxml
  def new
    @noticeboard_role_user = NoticeboardRoleUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.fxml  { render :fxml => @noticeboard_role_user }
    end
  end

  # GET /noticeboard_role_users/1/edit
  def edit
    @noticeboard_role_user = NoticeboardRoleUser.find(params[:id])
  end

  # POST /noticeboard_role_users
  # POST /noticeboard_role_users.fxml
  def create
    user = User.find(:first, :conditions => ["email_home LIKE ? OR email_work LIKE ?", params[:email], params[:email]]) if params[:email]
    params[:noticeboard_role_user][:user_id] = user.id
    @noticeboard_role_user = NoticeboardRoleUser.new(params[:noticeboard_role_user])

    respond_to do |format|
      if @noticeboard_role_user.save
        unless user.noticeboard_users.find_by_noticeboard_id(params[:noticeboard_id])
          is_active = @noticeboard_role_user.noticeboard_role.name =~ /(admin|moderator)/i ? true : false
          NoticeboardUser.create({:noticeboard_id => params[:noticeboard_id],:user_id => user.id, :is_active => is_active})
        end
        flash[:notice] = 'NoticeboardRoleUser was successfully created.'
        format.html { redirect_to(@noticeboard_role_user) }
        format.fxml  { render :fxml => @noticeboard_role_user}
      else
        format.html { render :action => "new" }
        format.fxml  { render :fxml => @noticeboard_role_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /noticeboard_role_users/1
  # PUT /noticeboard_role_users/1.fxml
  def update
    @noticeboard_role_user = NoticeboardRoleUser.find(params[:id])

    respond_to do |format|
      if @noticeboard_role_user.update_attributes(params[:noticeboard_role_user])
        flash[:notice] = 'NoticeboardRoleUser was successfully updated.'
        format.html { redirect_to(@noticeboard_role_user) }
        format.fxml  { render :fxml => @noticeboard_role_user}
      else
        format.html { render :action => "edit" }
        format.fxml  { render :fxml => @noticeboard_role_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /noticeboard_role_users/1
  # DELETE /noticeboard_role_users/1.fxml
  def destroy
    @noticeboard_role_user = NoticeboardRoleUser.find(params[:id])
    @noticeboard_role_user.destroy

    respond_to do |format|
      format.html { redirect_to(noticeboard_role_users_url) }
      format.fxml  { render :fxml => @noticeboard_role_user}
    end
  end
end
