class PriceTickersController < ApplicationController
  # GET /price_tickers
  # GET /price_tickers.xml
  def index
    @price_tickers = PriceTicker.find_all_by_feed_info_id(params[:feed_info_id])

    respond_to do |format|
      respond_to_do(format, @price_tickers)
    end
  end

  # GET /price_tickers/1
  # GET /price_tickers/1.xml
  def show
    @price_ticker = PriceTicker.find(params[:id])

    respond_to do |format|
      respond_to_do(format, @price_tickers)
    end
  end

  # GET /price_tickers/new
  # GET /price_tickers/new.xml
  def new
    @price_ticker = PriceTicker.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @price_ticker }
    end
  end

  # GET /price_tickers/1/edit
  def edit
    @price_ticker = PriceTicker.find(params[:id])
  end

  # POST /price_tickers
  # POST /price_tickers.xml
  def create
    @price_ticker = PriceTicker.new(params[:price_ticker])

    respond_to do |format|
      if @price_ticker.save
        flash[:notice] = 'PriceTicker was successfully created.'
        respond_to_do(format, @price_ticker)
      else
        respond_error_to_do(format, @price_ticker,"new")
      end
    end
  end

  # PUT /price_tickers/1
  # PUT /price_tickers/1.xml
  def update
    @price_ticker = PriceTicker.find(params[:id])

    respond_to do |format|
      if @price_ticker.update_attributes(params[:price_ticker])
        flash[:notice] = 'PriceTicker was successfully updated.'
        respond_to_do(format, @price_ticker)
      else
        respond_error_to_do(format, @price_ticker,"edit")
      end
    end
  end

  # DELETE /price_tickers/1
  # DELETE /price_tickers/1.xml
  def destroy
    @price_ticker = PriceTicker.find(params[:id])
    @price_ticker.destroy

    respond_to do |format|
      respond_to_do(format, @price_ticker)
    end
  end
end
