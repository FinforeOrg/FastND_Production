class ProfilesController < ApplicationController

  def index
    @profiles = Profile.find(:all,:include=>:profile_category)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @profiles }
    end
  end

end
