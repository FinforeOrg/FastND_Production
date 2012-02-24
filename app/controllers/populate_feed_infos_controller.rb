class PopulateFeedInfosController < ApplicationController
  # GET /populate_feed_infos
  # GET /populate_feed_infos.xml
  def index
    if current_user
      @populate_feed_infos = PopulateFeedInfo.find_by_tags(current_user,params[:category])
    else
      @populate_feed_infos = PopulateFeedInfo.all
    end      
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @populate_feed_infos }
      format.fxml  { render :fxml => @populate_feed_infos.to_fxml(:include => :feed_info) }
    end
  end

  # GET /populate_feed_infos/1
  # GET /populate_feed_infos/1.xml
  def show
    @populate_feed_info = PopulateFeedInfo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @populate_feed_info }
      format.fxml  { render :fxml => @populate_feed_info }
    end
  end

  # GET /populate_feed_infos/new
  # GET /populate_feed_infos/new.xml
  def new
    @populate_feed_info = PopulateFeedInfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @populate_feed_info }
      format.fxml  { render :fxml => @populate_feed_info }
    end
  end

  # GET /populate_feed_infos/1/edit
  def edit
    @populate_feed_info = PopulateFeedInfo.find(params[:id])
  end

  # POST /populate_feed_infos
  # POST /populate_feed_infos.xml
  def create
    info = params[:populate_feed_info]
    populate = PopulateFeedInfo.find_by_feed_info_id_and_profession_and_industry_and_geographic(info[:feed_info_id],info[:profession],info[:industry],info[:geographic])
    @populate_feed_info = populate ? populate : PopulateFeedInfo.new(info)

    respond_to do |format|
      if @populate_feed_info.save
        flash[:notice] = 'PopulateFeedInfo was successfully created.'
        format.html { redirect_to(@populate_feed_info) }
        format.xml  { render :xml => @populate_feed_info, :status => :created, :location => @populate_feed_info }
        format.fxml  { render :fxml => @populate_feed_info }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @populate_feed_info.errors, :status => :unprocessable_entity }
        format.fxml  { render :fxml => @populate_feed_info.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /populate_feed_infos/1
  # PUT /populate_feed_infos/1.xml
  def update
    @populate_feed_info = PopulateFeedInfo.find(params[:id])

    respond_to do |format|
      if @populate_feed_info.update_attributes(params[:populate_feed_info])
        flash[:notice] = 'PopulateFeedInfo was successfully updated.'
        format.html { redirect_to(@populate_feed_info) }
        format.xml  { head :ok }
        format.fxml  { render :fxml => @populate_feed_info }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @populate_feed_info.errors, :status => :unprocessable_entity }
        format.fxml  { render :fxml => @populate_feed_info.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /populate_feed_infos/1
  # DELETE /populate_feed_infos/1.xml
  def destroy
    @populate_feed_info = PopulateFeedInfo.find(params[:id])
    @populate_feed_info.destroy

    respond_to do |format|
      format.html { redirect_to(populate_feed_infos_url) }
      format.xml  { head :ok }
      format.fxml  { render :fxml => @populate_feed_info }
    end
  end
end
