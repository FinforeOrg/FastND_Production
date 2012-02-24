class ProfileCategoriesController < ApplicationController
  def index
    @profile_categories = ProfileCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @profile_categories }
    end
  end
end
