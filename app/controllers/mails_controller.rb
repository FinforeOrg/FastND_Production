class MailsController < ApplicationController
  require 'base64'
  require 'active_record_base_without_table'
  require 'gmail_xoauth'
  before_filter :require_user
  
  def index
    @mail = current_user.feed_accounts.find(params[:gid])
    @mails = []
    ids = []
    if @mail
      nebumail = Yacomail.new(@mail.account, Base64.decode64(Base64.decode64(@mail.password)))
      
      if nebumail.logged_in?
        nebumail.inbox(:all,{:after => 2.days.ago})
        nebumail.contents.reverse.each do |email|
          temp_id = (email.from.to_s.gsub(' ','_') + email.date.to_time.to_s.gsub(' ','_') + email.subject.to_s.gsub(' ','_'))
         unless ids.include? temp_id
           user_email = Mail.create({
                          :subject => email.subject, :sender=> email.from.to_s,
                          :receiver => email.to.to_s,:received_date => email.date.to_time,
                          :message => email.body_html
                        })
           user_email.id = rand(10000000000)
           ids << temp_id
           @mails << user_email
         end
        end

      end
    end

    respond_to do |format|
       respond_to_do(format,@mails)
     end
    rescue => e
      logger.debug e.to_s
      respond_to do |format|
         respond_to_do(format,@mails)
      end  
  end

  def messages
    fc = current_user.feed_accounts.find(params[:gid])
    ft = fc.feed_token
    fa = FeedApi.find_by_category('google')

    imap = Net::IMAP.new('imap.gmail.com', 993, usessl = true, certs = nil, verify = false)
    imap.authenticate('XOAUTH', ft.uid,
      :consumer_key => fa.api,
      :consumer_secret => fa.secret,
      :token => ft.token,
      :token_secret => ft.secret
    )
    imap.select('INBOX')

    since_date = Date.parse(2.days.ago.to_s).strftime("%d-%B-%Y")
    search = ["ALL", "SINCE", since_date]
    messages = []
    imap.search(search).each do |message_id|
      msg = imap.fetch(message_id,'RFC822')[0].attr['RFC822']
      from =msg.scan(/\nFrom\:.*?\r/ixm).join('').gsub(/^(From:)|\n|\r/ixm,'')
      to = msg.scan(/\nTo\:.*?\r/ixm).join('').gsub(/^(To:)|\n|\r/ixm,'')
      subject = msg.scan(/\nSubject\:.*?\r/ixm).join('').gsub(/^(Subject:)|\n|\r/ixm,'')
      date = msg.scan(/\nDate\:.*?\r/ixm).join('').gsub(/^(Date:)|\n|\r/ixm,'')
      reply_to = msg.scan(/\nReply-To\:.*?\r/ixm).join('').gsub(/^(Reply-To:)|\n|\r/ixm,'')
      boundary = msg.scan(/boundary\W.*?\r/ixm).join('').gsub(/\n|\r|boundary=|\"/ixm,'')
      msgs = msg.split(/#{boundary}.*?Content-Type\W/ixm)
      msg_html = msgs.select{|m| m if m.scan('text/html').size > 0}.join('')
      if msg_html != ""
        msg_html = msg_html.gsub(/text\/html\;.*Content-Transfer-Encoding\:.*?\r\n/ixm,'').gsub(/\r\n\W*#{boundary}\W*/ixm,'')
        msg_html = msg_html.gsub(/text\/html\;.*?charset\=.*?\r\n/ixm,'')
      else
        msg_html = msgs.size > 2 ? msgs[2] : msgs[1]
      end
      unless msg_html.scan(/Content-Disposition.*?attachment/ixm).size > 0
        msg_html = msg_html.gsub(/=09/ixm,">")
        messages.push({:sender=>from, :receiver=>to, :reply_to=>reply_to, :subject=>subject, :received_date=>date, :message=>msg_html})
      end
    end

    respond_to do |format|
      respond_to_do(format,messages)
    end

    rescue => e
      accident_alert(e.to_s)

  end

  def send_message
    ft = current_user.feed_accounts.find(params[:gid])
    email = params[:mail]
    message = <<MESSAGE_END
MIME-Version: 1.0
Content-type: text/html
Subject: #{email[:subject]}

#{email[:message_html]}
MESSAGE_END
    
    fa = FeedApi.find_by_category('google')
    smtp = Net::SMTP.new('smtp.gmail.com', 587)
    smtp.enable_starttls_auto
    secret = {
      :consumer_key => fa.api,
      :consumer_secret => fa.secret,
      :token => ft.token,
      :token_secret => ft.secret
    }
    smtp.start('gmail.com', ft.uid, secret, :xoauth)
      smtp.send_message message, ft.uid,ft.uid
    smtp.finish
    
    respond_to do |format|
      respond_to_do(format,{:status=>"SUCCESS"})
    end

    rescue => e
      accident_alert(e.to_s)
  end
     
  def create
    @mail = current_user.feed_accounts.find(params[:gid])
    email = params[:mail]
    require 'smtp-tls'
    GmailMailer.deliver_reply(params[:mail][:receiver], params[:mail][:subject], params[:mail][:message_html], @mail.account, Base64.decode64(Base64.decode64(@mail.password)))
    new_mail = Mail.create({:message_html=>params[:mail][:message_html]})
    new_mail.id = 0
    respond_to do |format|
       respond_to_do(format,@mails)
    end
  end

end
