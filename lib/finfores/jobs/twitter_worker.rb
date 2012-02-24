require 'twitter_oauth'

module Finfores
  module Jobs
    class TwitterWorker
      attr_accessor :column, :twitters, :tweetauth

      def initialize(task_type, column_id, twitter_ids)
        @twitters = YAML.load twitter_ids
        @column = FeedAccount.find(column_id)
	if @column
	  @tweetauth = prepare_twitter_oauth
	  send(task_type.to_s.downcase) if @tweetauth
	end
      end

      def follow
        @twitters.each do |friend_id|
          @tweetauth.friend(friend_id)
	end
      end

      def unfollow
        @twitters.each do |friend_id|
          @tweetauth.unfriend(friend_id)
	end
      end

      def prepare_twitter_oauth
        auth_info = @column.feed_token
	api = FeedApi.twitter
	return  TwitterOAuth::Client.new(:consumer_key => api.api,
	                                 :consumer_secret => api.secret,
	  	   		         :token => auth_info.token,
  	                                 :secret => auth_info.secret)
        rescue => e
	  return nil
      end
    end
  end
end