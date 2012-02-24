namespace :finfore do

  desc "create feed"
  task :import_csv  => :environment do
    require 'fastercsv'
    require 'date'

    # Settings
    @csv_file = "db/csv/Suggestion_List_Upload May 26.csv";       # CSV-file to read

    def start_load_csv
      total = 0
      success = 0
      failed = 0
      FasterCSV.foreach(@csv_file) do |row|
        unless (row[0] == "title" && row[1] == "type") || (row[0].blank? && row[1].blank?)
          new_feed_info = FeedInfo.new

          print "Searching for '#{row[2]}' in users: "
           feed_info = FeedInfo.find_by_address(row[2])

          if feed_info
            print "FOUND!\n"
          else
            print "Creating FeedInfo, '#{row[2]}': "
            new_feed_info.title = row[0]
            new_feed_info.category = row[1]
            new_feed_info.address = row[2]
            new_feed_info.follower = 0
            new_feed_info.tag_profession = row[4]
            new_feed_info.tag_geographic = row[5]
            new_feed_info.tag_industry = row[6]
            total = total + 1
            if new_feed_info.save!
              print "OK\n\n"
              success = success + 1
            else
              print "FAILED!!\n\n"
              failed = failed + 1
            end
          end
        end
      end

      puts "TOTAL: #{total}\n"
      puts "SAVED: #{success}\n"
      puts "FAILS: #{failed}\n"
    end

    start_load_csv

  end
end
