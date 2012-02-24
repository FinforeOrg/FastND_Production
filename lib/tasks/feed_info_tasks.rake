namespace :feed_info do
  desc "re-populate regulatory and its category database"
  task :update_twitter => :environment do
    #!/usr/bin/ruby
    # yacobus.reinhart@gmail.com
     
    require 'open-uri'
    require 'net/http'

    def getQuotes(feed_info)
      followerQuery = /follower_count\W.*>(.*)<\/span>/
      followingQuery = /following_count\W.*>(.*)<\/span>/
      firstNameQuery = /\Wfn\W>\w.*<\/span>/
      locationQuery = /\Wadr\W>\w.*<\/span>/
      listQuery = /lists_count\W.*>(.*)<\/span>/
      followNo = /((\w*\W\s)|(<\/)).*?>|(\,|\.)/
      cleanTag = /(.*\W|\w*)>|<\/.*>/
      
      h = Net::HTTP.new('twitter.com')
      response = h.get('/'+feed_info.address)

      if response.message == "OK"
         follower = response.body.scan(followerQuery)[0].to_a.join.gsub(followNo,"")
         #following = response.body.scan(followingQuery)[0].to_a.join.gsub(followNo,"")
         #full_name = response.body.scan(firstNameQuery)[0].to_a.join.gsub(cleanTag,"")
         #location = response.body.scan(locationQuery)[0].to_a.join.gsub(cleanTag,"")
         #total_list = response.body.scan(listQuery)[0].to_a.join.gsub(followNo,"")

         feed_info.update_attribute(:follower, follower) if follower.to_i > 0
      end
    end

    conditions = "category not in ('Company', 'Index', 'Currency') AND address !~* 'https?://'"
    feed_infos = FeedInfo.find(:all, :conditions=> conditions)
    feed_infos.each do |info_feed|
       getQuotes(info_feed)
    end
  end
end