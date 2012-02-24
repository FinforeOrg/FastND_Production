namespace :finfore do

  desc "export feed info"
  task :export_feed_info_csv  => :environment do
    require 'fastercsv'
    require 'date'

    def start_export_csv
      ['chart', 'rss', 'podcast', 'broadcast', 'twitter', 'company', 'all_companies'].each do |category|
        if category == 'company' || category == 'all_companies'
          category_in = (category == 'all_companies') ? "('Company')" : "('Company', 'Index', 'Currency')"
          conditions = "(category in "+category_in+" OR (address ~* E'^\\k*' AND address !~* E'\\s+')) AND address !~* 'https?://' AND category not in ('Chart')"
          #conditions = conditions + " AND company_competitors.keyword IS NOT NULL" if category == 'all_companies' && current_user
        elsif category == 'rss'
          conditions = "feed_infos.address ~* 'https?://' AND feed_infos.address !~* 'youtube' AND feed_infos.address !~* 'podcast' AND feed_infos.address !~* 'vodcast' AND feed_infos.address !~* 'video' AND feed_infos.address !~* 'audio' AND feed_infos.address !~* 'mp3'" 
        elsif category == 'podcast'
          conditions = "address ~* 'https?://' AND feed_infos.address !~* 'youtube' AND (address ~* 'podcast' OR address ~* 'audio' OR address ~* 'media' OR address ~* 'vodcast' OR address ~* 'video')"
        elsif category == 'broadcast'
          conditions = "address ~* 'https?://' AND address ~* 'youtube'"
        elsif category == 'chart' || category == 'price'
          conditions = "title != address AND address IS NOT NULL AND address != '' AND category = 'Chart' AND title IS NOT NULL AND title != ''"
        elsif category == 'twitter'
          conditions = "category not in ('Company', 'Index', 'Currency') AND address !~* 'https?://'"
        end
      
        @heads = FeedInfo.columns.map {|c| c.name }
        
        if category == 'all_companies'
          @head_competitors = CompanyCompetitor.columns.map {|c| c.name }
          @heads = @heads.concat(@head_competitors)
        end
        
        @list = FeedInfo.all(:conditions => conditions)
        
        csv_string = FasterCSV.generate do |csv|
          csv << @heads
          @list.each do |feed_info|
            feed_info_data = []
            @heads.each do |column|
              feed_info_data << feed_info[column]  
            end
            if category == 'all_companies'
              @head_competitors.each do |column|
                feed_info_data << feed_info.company_competitor[column]  
              end if feed_info.company_competitor
            end
            csv << feed_info_data
          end
        end
        
        time = Time.new
        time_str = time.strftime("%Y%m%d")
        filename = "public/"+@list.first.class.name.downcase+"_"+category+"_"+time_str+".csv"
        quotes_file = File.open(filename,"a")
        quotes_file.puts csv_string
        quotes_file.close
        
      end
    end

    start_export_csv

  end
end
