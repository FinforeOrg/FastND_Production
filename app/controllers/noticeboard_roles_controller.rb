class NoticeboardRolesController < ApplicationController
  # GET /noticeboard_roles
  # GET /noticeboard_roles.fxml
  def index
    @noticeboard_roles = NoticeboardRole.all

    respond_to do |format|
      format.html # index.html.erb
      format.fxml  { render :fxml => @noticeboard_roles }
    end
  end

  # GET /noticeboard_roles/1
  # GET /noticeboard_roles/1.fxml
  def show
    @noticeboard_role = NoticeboardRole.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.fxml  { render :fxml => @noticeboard_role }
    end
  end

  # GET /noticeboard_roles/new
  # GET /noticeboard_roles/new.fxml
  def new
    @noticeboard_role = NoticeboardRole.new

    respond_to do |format|
      format.html # new.html.erb
      format.fxml  { render :fxml => @noticeboard_role }
    end
  end

  # GET /noticeboard_roles/1/edit
  def edit
    @noticeboard_role = NoticeboardRole.find(params[:id])
  end

  # POST /noticeboard_roles
  # POST /noticeboard_roles.fxml
  def create
    @noticeboard_role = NoticeboardRole.new(params[:noticeboard_role])

    respond_to do |format|
      if @noticeboard_role.save
        flash[:notice] = 'NoticeboardRole was successfully created.'
        format.html { redirect_to(@noticeboard_role) }
        format.fxml  { render :fxml => @noticeboard_role}
      else
        format.html { render :action => "new" }
        format.fxml  { render :fxml => @noticeboard_role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /noticeboard_roles/1
  # PUT /noticeboard_roles/1.fxml
  def update
    @noticeboard_role = NoticeboardRole.find(params[:id])

    respond_to do |format|
      if @noticeboard_role.update_attributes(params[:noticeboard_role])
        flash[:notice] = 'NoticeboardRole was successfully updated.'
        format.html { redirect_to(@noticeboard_role) }
        format.fxml  { render :fxml => @noticeboard_role }
      else
        format.html { render :action => "edit" }
        format.fxml  { render :fxml => @noticeboard_role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /noticeboard_roles/1
  # DELETE /noticeboard_roles/1.fxml
  def destroy
    @noticeboard_role = NoticeboardRole.find(params[:id])
    @noticeboard_role.destroy

    respond_to do |format|
      format.html { redirect_to(noticeboard_roles_url) }
      format.fxml  { render :fxml => @noticeboard_role }
    end
  end
end
