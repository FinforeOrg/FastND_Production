class PriceChartsController < ApplicationController
  require 'hpricot'
#  require 'google-spreadsheet'
  skip_before_filter :require_user, :only => [:google_finance, :gadget_price]
  before_filter :setup_client, :except => [:graph, :gadget_finance, :gadget_price]
  
  def graph
    @ticker = params[:ticker]
    @embed_at = Date.today.to_s
  end
  
  def gadget_finance
    render :layout => false
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end
  
  def gadget_price 
    @rss_chart = <<-EOF
        <rss xmlns:dc="http://purl.org/dc/elements/1.1/"  xmlns:atom="http://www.w3.org/2005/Atom" >
          <chanel>
      EOF
     
    counter = 0
    arr_tickers = params[:tickers].split("|")
    
    arr_tickers.each do |ticker|
      unless ticker.blank?
        getQuotes(ticker)
      end
    end if arr_tickers.size > 0
    @rss_chart  <<"</chanel></rss>"
                             
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rss_chart }
      format.fxml { render :fxml => @rss_chart }
      format.json { render :json => Hash.from_xml(@rss_chart)}
    end
  end
  
  private
    def getQuotes(symbol)
      h = Net::HTTP.new('www.google.com')
      response = h.get('/finance?q='+symbol)
      
      if response.message == "OK"
         co = response.body.scan(/_companyName = '(.*)';/)[0].to_a.join
         pr = response.body.scan(/class="pr">[\n].*">([0-9]*\.?[0-9]*)<\/span>/)[0].to_a.join
         chg = response.body.scan(/class="ch bld">.*">([-+]?[0-9]*\.?[0-9]*)<\/span>/)[0].to_a.join
         chg_pct = response.body.scan(/class="ch[g|r]".*">(\([-+]?[0-9]*\.?[0-9]*%\))<\/span>/)[0].to_a.join
         #hi = response.body.scan(/Range<\/span>\n.*">([0-9]*\.?[0-9]*) - [0-9]*\.?[0-9]*<\/span>/)[0].to_a.join
         #low = response.body.scan(/Range<\/span>\n.*">[0-9]*\.?[0-9]* - ([0-9]*\.?[0-9]*)<\/span>/)[0].to_a.join
         #year_hi = response.body.scan(/ week<\/span>\n.*">([0-9]*\.?[0-9]*) - [0-9]*\.?[0-9]*<\/span>/)[0].to_a.join
         #year_low = response.body.scan(/ week<\/span>\n.*">[0-9]*\.?[0-9]* - ([0-9]*\.?[0-9]*)<\/span>/)[0].to_a.join
         #open = response.body.scan(/Open<\/span>\n.*">([0-9]*\.?[0-9]*)<\/span>/)[0].to_a.join
         vol = response.body.scan(/Vol\.<\/span>\n.*goog-inline-block val">(.*)<\/span>/)[0].to_a.join
         #avg_vol = response.body.scan(/Vol\/Avg\.<\/span>\n.*goog-inline-block val">(.*)<\/span>/)[0].to_a.join
         mkt_cap = response.body.scan(/Mkt cap<\/span>\n.*goog-inline-block val">(.*)<\/span>/)[0].to_a.join.gsub("<span class=dis>*</span>","")
         pe = response.body.scan(/P\/E<\/span>\n.*goog-inline-block val">(.*)<\/span>/)[0].to_a.join
         #div = response.body.scan(/Div\/yield<\/span>\n.*goog-inline-block val">(.*)<\/span>/)[0].to_a.join
         # yld = response.body.scan(/Div\/yield<\/span>\n.*goog-inline-block val">.*\/(.*)<\/span>/)[0].to_a.join
         #eps = response.body.scan(/EPS<\/span>\n.*">([0-9]*\.?[0-9]*)<\/span>/)[0].to_a.join
         #shares = response.body.scan(/Shares<\/span>\n.*goog-inline-block val">(.*)<\/span>/)[0].to_a.join
         #beta = response.body.scan(/Beta<\/span>\n.*">([0-9]*\.?[0-9]*)<\/span>/)[0].to_a.join
         #nst_own = response.body.scan(/Inst. own<\/span>\n.*">([0-9]*\.?[0-9]*%)<\/span>/)[0].to_a.join
         @rss_chart <<"
                    <chart>
                      <company_name>#{co}</company_name>
                      <google_ticker>#{symbol}</google_ticker>
                      <price>#{pr}</price>
                      <chg>#{chg}</chg>
                      <pct_chg>#{chg_pct}</pct_chg>
                      <vol>#{vol}</vol>
                      <mkt_cap>#{mkt_cap}</mkt_cap>
                      <pe_ratio>#{pe}</pe_ratio>
                    </chart>
                  "
      end
    end
  
end
