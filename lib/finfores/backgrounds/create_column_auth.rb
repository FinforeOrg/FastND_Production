module Finfores
  module Backgrounds
    class CreateColumnAuth
      @queue = "CreateColumnFromOAuthLogin"
      
      def self.perform(access_token_id)
        Finfores::Jobs::OmniauthFeedAccount.new(access_token_id)
      end
      
    end
  end
end