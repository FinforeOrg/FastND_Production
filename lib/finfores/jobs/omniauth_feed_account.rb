module Finfores
  module Jobs
    class OmniauthFeedAccount
      attr_accessor :access_token, :user
      
      def initialize(access_token_id)
        @access_token = AccessToken.find access_token_id
        create_feed_account if @access_token 
      end
      
      def create_feed_account
        feed_token = FeedToken.find_by_uid(@access_token.uid)
        title = @access_token.category
        account = @access_token.uid
        
        unless feed_token
          feed_account = FeedAccount.create({:category=>@access_token.category, :account => account, :name => title,:user_id => @access_token.user_id, :window_type => "tab"})
          feed_token = FeedToken.create({:user_id => @access_token.user_id,:feed_account_id => feed_account.id, :token => @access_token.token, :secret => @access_token.secret,:uid=>@access_token.uid}) if feed_account
        else
          feed_token.update_attributes({:token => access_token.token,
                                                     :secret => access_token.secret,
                                                     :token_preauth => "",
                                                     :secret_preauth => "",
                                                     :url_oauth => ""
                                                   })
        end
      end
      
    end
  end
end
