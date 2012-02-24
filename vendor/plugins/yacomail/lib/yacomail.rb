# Yacomail
require 'net/imap'
require 'tmail_mail_extension'

class Object
  def to_imap_date
    Date.parse(to_s).strftime("%d-%B-%Y")
  end
end

class Yacomail
  VERSION  = '0.0.1'
  MAIL_HOST = 'imap.gmail.com'
  MAIL_PORT = 993
  MAIL_SSL = true
  UID_BLOCK_SIZE = 1024
  EMAIL_FLAG = {
                 :all => ['ALL'],
                 :unread => ['UNSEEN'],
                 :read => ['SEEN']
               }

  def initialize(username, password)
    @contents = []
    @imap = Net::IMAP.new(MAIL_HOST, MAIL_PORT, MAIL_SSL)

    status = @imap.login(username, password)
    @logged_in = true if status.name == 'OK'
    imap
  end

  def logged_in?
    !!@logged_in
  end

  def imap
    @imap
  end

  def trace(message)
    puts "Imap Trace: #{message}"
  end


  def uid_fetch_block(server, uids, *args)
    pos = 0
    while pos < uids.size
      server.uid_fetch(uids[pos, UID_BLOCK_SIZE], *args).each {|data| yield data }
      pos += UID_BLOCK_SIZE
    end
  end

  def inbox(key_or_opts = :all, opts={})

    search  = read_email_by(key_or_opts, opts)
    message_info = {}

    unless opts.empty?
      search  = search_email_by(opts, search)
    else
      opts = key_or_opts
    end

    # Open source folder in read-only mode.
    begin
      #trace "Selecting folder 'INBOX'..."
      imap.examine('INBOX')
    rescue => e
      trace "Error: select failed: #{e}"
    end

    # Open (or create) destination folder in read-write mode.
    begin
      #trace "Selecting folder 'INBOX'..."
      imap.select('INBOX')
    rescue => e
      trace "Error: could not create folder: #{e}"
    end

    uids = imap.uid_search(search)

    if uids.length > 0
      uid_fetch_block(imap, uids, ['ENVELOPE']) do |data|
        message_id = data.attr['ENVELOPE'].message_id

        # If this message is already in the destination folder, skip it.
        if message_info[message_id]
          next
        end

        # Download the full message body from the source folder.
        #trace "Downloading message #{message_id}..."
        messages = imap.uid_fetch(data.attr['UID'], ['RFC822'])

        # Append the message to the destination folder, preserving flags and
        # internal timestamp.
        #trace "Storing message #{message_id}..."

        messages.each do |message|
          @contents << TMail::Mail.parse(message.attr['RFC822'])
        end
      end
    end

  end

  def contents
    @contents
  end


  private
    def read_email_by(key_or_opts, opts)
      if key_or_opts.is_a?(Hash) && opts.empty?
        search = EMAIL_FLAG[:all]
      elsif key_or_opts.is_a?(Symbol) && opts.is_a?(Hash)
        search = EMAIL_FLAG[key_or_opts]
      elsif key_or_opts.is_a?(Array) && opts.empty?
        search = key_or_opts
      else
        raise ArgumentError, "Couldn't make sense of arguments to #emails - should be an optional hash of options preceded by an optional read-status bit; OR simply an array of parameters to pass directly to the IMAP uid_search call."
      end
      search
    end

    def search_email_by(opts,search)
      search.concat ['SINCE', opts[:after].to_imap_date] if opts[:after]
      search.concat ['BEFORE', opts[:before].to_imap_date] if opts[:before]
      search.concat ['ON', opts[:on].to_imap_date] if opts[:on]
      search.concat ['FROM', opts[:from]] if opts[:from]
      search.concat ['TO', opts[:to]] if opts[:to]
      search
    end
end