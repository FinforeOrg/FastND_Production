#require 'memcache'
require "redis-store"

#memcache_options = {
#  :c_threshold => 10_000,
#  :compression => true,
#  :debug => false,
#  :namespace => 'finfore_development',
#  :readonly => false,
#  :urlencode => false
#}

#CACHE = MemCache.new memcache_options

# These are the IP addresses and ports of the memcached servers
#CACHE.servers = ['127.0.0.1:1121']

# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true
config.action_controller.session_store = :redis_session_store
#:mem_cache_store
#:cookie_store
# See everything in the log (default is :info)
# config.log_level = :debug
 config.log_level = :error
# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store
#config.cache_store = :file_store, "/var/cache/finfore_production/"
config.cache_store = :redis_store
#:mem_cache_store, 'localhost', '127.0.0.1:11211',{:namespace => 'finfore_development'}

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!
#ActionController::Base.session_options[:cache] = CACHE
ActionController::Base.session_store = :redis_session_store
