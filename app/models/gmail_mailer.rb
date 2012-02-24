class GmailMailer < ActionMailer::Base
 def load_settings(username,password)
    @@smtp_settings = {
      :enable_starttls_auto => true,
      :address => "smtp.gmail.com",
      :port => 587,
      :domain => username.split("@")[1],
      :authentication => :plain,
      :user_name => username,
      :password => password
    }
  end

  def reply(recipient, subject, message, username, password)
    load_settings(username,password)
    @subject =    subject
    @recipients = recipient
    @from =       username
    @sent_on =    Time.now
    @content_type = "text/html"
    @body =       {:message => message}
  end

end
