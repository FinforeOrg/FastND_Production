class CompanyCompetitorsController < ApplicationController
  # GET /company_competitors
  # GET /company_competitors.xml
  def index
    @company_competitors = CompanyCompetitor.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @company_competitors }
      format.fxml { render :fxml => @company_competitors.to_fxml(:include => :feed_info) }
    end
  end

  # GET /company_competitors/1
  # GET /company_competitors/1.xml
  def show
    @company_competitor = CompanyCompetitor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @company_competitor }
      format.fxml  { render :fxml => @company_competitor }
    end
  end

  # GET /company_competitors/new
  # GET /company_competitors/new.xml
  def new
    @company_competitor = CompanyCompetitor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @company_competitor }
    end
  end

  # GET /company_competitors/1/edit
  def edit
    @company_competitor = CompanyCompetitor.find(params[:id])
  end

  # POST /company_competitors
  # POST /company_competitors.xml
  def create
    params[:company_competitor][:company_keyword] = params[:company_competitor][:company_keyword].to_s
    params[:company_competitor][:keyword] = params[:company_competitor][:keyword].to_s
    @company_competitor = CompanyCompetitor.new(params[:company_competitor])

    respond_to do |format|
      if @company_competitor.save
        flash[:notice] = 'CompanyCompetitor was successfully created.'
        format.html { redirect_to(@company_competitor) }
        format.xml  { render :xml => @company_competitor, :status => :created, :location => @company_competitor }
        format.fxml  { render :fxml => @company_competitor.to_fxml(:include => :feed_info) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @company_competitor.errors, :status => :unprocessable_entity }
        format.fxml  { render :fxml => @company_competitor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /company_competitors/1
  # PUT /company_competitors/1.xml
  def update
    @company_competitor = CompanyCompetitor.find(params[:id])
    params[:company_competitor][:company_keyword] = params[:company_competitor][:company_keyword].to_s
    params[:company_competitor][:keyword] = params[:company_competitor][:keyword].to_s
    respond_to do |format|
      if @company_competitor.update_attributes(params[:company_competitor])
        flash[:notice] = 'CompanyCompetitor was successfully updated.'
        format.html { redirect_to(@company_competitor) }
        format.xml  { head :ok }
        format.fxml  { render :fxml => @company_competitor.to_fxml(:include => :feed_info) }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company_competitor.errors, :status => :unprocessable_entity }
        format.fxml  { render :fxml => @company_competitor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /company_competitors/1
  # DELETE /company_competitors/1.xml
  def destroy
    @company_competitor = CompanyCompetitor.find(params[:id])
    @company_competitor.destroy

    respond_to do |format|
      format.html { redirect_to(company_competitors_url) }
      format.xml  { head :ok }
      format.fxml  { render :fxml => @company_competitor }
    end
  end
end
