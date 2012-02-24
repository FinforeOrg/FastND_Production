RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
    config.gem "restfulx"
    config.gem "authlogic"
    config.gem "json"
    config.gem "oauth"
    config.gem "oauth2" # facebook only
    config.gem "httparty"
    config.gem "gdata"
    config.gem "resque"
    config.gem "rack"
    config.gem "redis"
    config.gem "redis-namespace"
    config.gem "newrelic_rpm"
    config.gem "twitter_oauth"
    #config.gem "resque-pool"
    #config.gem "resque-status", :lib => 'resque/status'
    config.time_zone = 'UTC'
end


require 'smtp-tls'
require 'oauth'
class OAuth::Consumer
     def marshal_load(*args)
      self
    end
end

ActionMailer::Base.smtp_settings = {
  :address => "secure.emailsrvr.com",
  :port => 587,
  :domain => "finfore.net",
  :authentication => :plain,
  :user_name => "info@finfore.net",
  :password => "44London",
  :enable_starttls_auto => true
}

require 'linkedin'
require 'twitter_oauth'
require 'net/http'
require 'fgraph'
