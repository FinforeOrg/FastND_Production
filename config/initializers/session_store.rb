# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_finfore_session',
  :secret      => '65f7811ec77f15d8187a76e1450c2ac4f9aba7fdbe7ae0fb1ffc0921df4dd3af22688aa8cf8135d2d6f2a085ba7822def3816039cb476f025fe2c2335eb153d5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
