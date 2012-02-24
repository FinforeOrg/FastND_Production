module Finfores
  module Jobs
    class WelcomeEmail
      attr_accessor :user, :password
      
      def initialize(uid,password)
        @user = User.find uid
        @password = password
        sent_email if @user
      end
      
      def sent_email
        UserMailer.deliver_welcome_email(@user,@password)
        UserMailer.deliver_new_user_to_admin(@user)
      end
      
    end
  end
end