require 'yaml'
module Finfores
  module Jobs
    class AlertWorker
      attr_accessor :user
      def initialize(category,options)
        options = YAML.load options
        @user = User.find(options[:user]) unless options[:user].blank?
        send(category,options)
      end

      def forgot_password options
        UserMailer.deliver_forgot_password(@user,options[:password])
      end

      def missing_suggestion options
        UserMailer.deliver_missing_suggestion(@user,options[:category])
      end

      def welcome_email options
        UserMailer.deliver_welcome_email(@user,options[:password])
	UserMailer.deliver_new_user_to_admin(@user)
      end

      def contact_admin options
        UserMailer.deliver_user_speak(options)
      end

    end
  end
end
