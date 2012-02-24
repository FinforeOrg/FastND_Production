class UserCompanyTabsController < ApplicationController
  # GET /user_company_tabs
  # GET /user_company_tabs.xml
  before_filter :check_remember_tab, :only => [:create]
  def index
    if current_user
      @user_company_tabs = UserCompanyTab.find_all_by_user_id(current_user.id)
      sort_tabs_by_remembering
    end
    
    respond_to do |format|
      respond_to_do(format,@user_company_tabs,{:feed_info=>{:include=>{:company_competitor=>{:except=>[:created_at,:updated_at]},
                                                                       :profiles=>{:only=>[:id,:title],
                                                                                   :include=>{:profile_category=>{:only=>[:id,:title]}}
                                                                                  }
                                                                       }
                                                            }})
    end
  end

  # GET /user_company_tabs/1
  # GET /user_company_tabs/1.xml
  def show
    @user_company_tab = UserCompanyTab.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_company_tab }
    end
  end

  # GET /user_company_tabs/new
  # GET /user_company_tabs/new.xml
  def new
    @user_company_tab = UserCompanyTab.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_company_tab }
    end
  end

  # GET /user_company_tabs/1/edit
  def edit
    @user_company_tab = UserCompanyTab.find(params[:id])
  end

  # POST /user_company_tabs
  # POST /user_company_tabs.xml
  def create
    if current_user
      tabs = current_user.user_company_tabs
      @user_company_tab = UserCompanyTab.new(params[:user_company_tab])
    end  
    

    respond_to do |format|
      if @user_company_tab.save
        flash[:notice] = 'UserCompanyTab was successfully created.'
        respond_to_do(format,@user_company_tab,{:feed_info=>{:include=>{:company_competitor=>{:except=>[:created_at,:updated_at]},
                                                                       :profiles=>{:only=>[:id,:title],
                                                                                   :include=>{:profile_category=>{:only=>[:id,:title]}}
                                                                                  }
                                                                       }
                                                            }})

      else
        respond_error_to_do(format,@user_company_tab,"new")
      end
    end if @user_company_tab

    
  end

  # PUT /user_company_tabs/1
  # PUT /user_company_tabs/1.xml
  def update
    @user_company_tab = UserCompanyTab.find(params[:id])

    respond_to do |format|
      if @user_company_tab.update_attributes(params[:user_company_tab])
        flash[:notice] = 'UserCompanyTab was successfully updated.'
        respond_to_do(format,@user_company_tab,{:feed_info=>{:include=>{:company_competitor=>{:except=>[:created_at,:updated_at]},
                                                                       :profiles=>{:only=>[:id,:title],
                                                                                   :include=>{:profile_category=>{:except=>[:id,:title]}}
                                                                                  }
                                                                       }
                                                            }})

      else
        respond_error_to_do(format,@user_company_tab,"edit")
      end
    end
  end

  # DELETE /user_company_tabs/1
  # DELETE /user_company_tabs/1.xml
  def destroy
    @user_company_tab = UserCompanyTab.find(params[:id])
    @user_company_tab.destroy

    respond_to do |format|
      format.html { redirect_to(user_company_tabs_url) }
      format.xml  { render :xml => @user_company_tab, :status => 200 }
      format.json { render :json => @user_company_tab, :status => 200  }
      format.fxml { render :fxml => @user_company_tab.to_fxml(:include => :feed_info)}
    end
  end

  private
    def sort_tabs_by_remembering
      unless current_user.remember_companies.blank?
        tmpArr = []
        current_user.remember_companies.split("|").each do |key|
          @user_company_tabs.each do |tab|
            if key == tab.id.to_s
              tmpArr.push(tab)
              break
            end
          end
        end
	diff = @user_company_tabs - tmpArr
        @user_company_tabs = tmpArr + diff
      end
    end

    def check_remember_tab
      if current_user && current_user.remember_companies.blank?
        @user_company_tabs = UserCompanyTab.find_all_by_user_id(current_user.id)
	if @user_company_tabs.size > 0
          tab_ids = @user_company_tabs.map(&:id).join("|")
	  current_user.update_attribute(:remember_companies,tab_ids)
	end
      end
    end

end
