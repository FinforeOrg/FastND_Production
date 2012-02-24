class KeywordColumnsController < ApplicationController
  #skip_before_filter :require_user
  def index
    if current_user
      @keyword_columns = params[:feed_account_id].blank? ? current_user.keyword_columns : KeywordColumn.find_all_by_user_id_and_feed_account_id(current_user.id,params[:feed_account_id])
    else
      @keyword_columns = []
    end
    
    respond_to do |format|
      respond_to_do(format, @keyword_columns)
    end
  end

  # GET /keyword_columns/1
  # GET /keyword_columns/1.xml
  # GET /keyword_columns/1.fxml
  def show
    @keyword_column = KeywordColumn.find(params[:id])

    respond_to do |format|
      respond_to_do(format, @keyword_column)
    end
  end

  # GET /keyword_columns/new
  # GET /keyword_columns/new.xml
  def new
    @keyword_column = KeywordColumn.new

    respond_to do |format|
      respond_to_do(format, @keyword_column)
    end
  end

  # GET /keyword_columns/1/edit
  def edit
    @keyword_column = KeywordColumn.find(params[:id])
  end

  # POST /keyword_columns
  # POST /keyword_columns.xml
  # POST /keyword_columns.fxml
  def create
    keyword_col = params[:keyword_column]
    
    arr_key = keyword_col[:keyword].split(",")
    
    arr_key.each do |key|
      create_or_update_feed_info(key,params[:category])
    end
    keyword = KeywordColumn.find_by_user_id_and_feed_account_id(current_user.id, keyword_col[:feed_account_id])
    unless keyword
      @keyword_column = KeywordColumn.create(keyword_col)
    else
      keyword.update_attributes(params[:keyword_column])
      @keyword_column = keyword.reload
    end
    respond_to do |format|
      if @keyword_column
        respond_to_do(format, @keyword_column)
      else
        respond_error_to_do(format,@keyword_column,"new")
      end
    end
  end

  # PUT /keyword_columns/1
  # PUT /keyword_columns/1.xml
  # PUT /keyword_columns/1.fxml
  def update
    @keyword_column = KeywordColumn.find(params[:id])
    @saved = @keyword_column.update_attributes(params[:keyword_column])

    respond_to do |format|
      if @saved
        respond_to_do(format, @keyword_column)
      else
        respond_error_to_do(format,@keyword_column,"edit")
      end
    end
  end

  # DELETE /keyword_columns/1
  # DELETE /keyword_columns/1.xml
  # DELETE /keyword_columns/1.fxml
  def destroy
    @keyword_column = KeywordColumn.find(params[:id])
    @keyword_column.destroy

    respond_to do |format|
      respond_to_do(format, @keyword_column)
    end
  end
end
