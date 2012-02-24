# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110921090003) do

  create_table "access_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "category",     :limit => 30
    t.string   "long_key"
    t.string   "token",        :limit => 1024
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid"
    t.text     "user_profile"
  end

  add_index "access_tokens", ["long_key"], :name => "index_access_tokens_on_key", :unique => true

  create_table "admin_cores", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "role_id"
    t.string   "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blogs", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "author"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "company_competitors", :force => true do |t|
    t.integer  "feed_info_id"
    t.text     "keyword"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "competitor_ticker"
    t.text     "company_keyword"
    t.text     "broadcast_keyword"
    t.text     "finance_keyword"
    t.text     "bing_keyword"
    t.text     "blog_keyword"
    t.string   "company_ticker"
  end

  create_table "contents", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tab_title"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["locked_by"], :name => "index_delayed_jobs_on_locked_by"

  create_table "email_notification_delays", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feed_accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "category"
    t.string   "account"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password"
    t.string   "window_type"
  end

  create_table "feed_apis", :force => true do |t|
    t.string   "api"
    t.string   "secret"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feed_infos", :force => true do |t|
    t.string   "title"
    t.string   "address"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "follower"
    t.string   "image"
    t.text     "description"
    t.boolean  "is_populate"
  end

  create_table "feed_infos_profiles", :id => false, :force => true do |t|
    t.integer  "feed_info_id"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feed_tokens", :force => true do |t|
    t.integer  "user_id"
    t.integer  "feed_account_id"
    t.string   "token"
    t.string   "secret"
    t.string   "token_preauth"
    t.string   "secret_preauth"
    t.string   "url_oauth"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid"
  end

  create_table "homes", :force => true do |t|
    t.string   "company_name"
    t.string   "title"
    t.string   "web_keyword"
    t.string   "web_description"
    t.string   "front_page_title"
    t.text     "front_page"
    t.string   "about_page_title"
    t.text     "about_page"
    t.string   "legal_page_title"
    t.text     "legal_page"
    t.string   "faq_title"
    t.text     "faq_page"
    t.string   "contact_page_title"
    t.text     "contact_page"
    t.string   "web_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keyword_columns", :force => true do |t|
    t.integer  "user_id"
    t.string   "keyword"
    t.boolean  "is_aggregate"
    t.integer  "follower"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "feed_account_id"
  end

  create_table "linkedin_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_errors", :force => true do |t|
    t.integer  "user_id"
    t.integer  "admin_core_id"
    t.string   "title"
    t.text     "error_message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logged_exceptions", :force => true do |t|
    t.string   "exception_class"
    t.string   "controller_name"
    t.string   "action_name"
    t.text     "message"
    t.text     "backtrace"
    t.text     "environment"
    t.text     "request"
    t.datetime "created_at"
  end

  create_table "most_followeds", :force => true do |t|
    t.string   "category"
    t.string   "twitter"
    t.integer  "total"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "feed_info_id"
  end

  create_table "noticeboard_comments", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.integer  "noticeboard_post_id"
    t.boolean  "is_publish"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "noticeboard_id"
  end

  create_table "noticeboard_posts", :force => true do |t|
    t.integer  "noticeboard_id"
    t.string   "title"
    t.text     "content"
    t.boolean  "is_publish"
    t.integer  "user_id"
    t.string   "tags"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "noticeboard_role_users", :force => true do |t|
    t.integer  "noticeboard_role_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "noticeboard_id"
  end

  create_table "noticeboard_roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "noticeboard_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "noticeboard_id"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "invitation_note"
    t.boolean  "is_user_remove"
  end

  create_table "noticeboards", :force => true do |t|
    t.string   "name"
    t.boolean  "auto_publish_comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "populate_feed_infos", :force => true do |t|
    t.integer  "feed_info_id"
    t.string   "profession"
    t.string   "geographic"
    t.string   "industry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_company_tab"
  end

  create_table "populate_feed_infos_profiles", :id => false, :force => true do |t|
    t.integer  "populate_feed_info_id"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "price_tickers", :force => true do |t|
    t.integer  "feed_info_id"
    t.string   "ticker"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profile_categories", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "profile_category_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_private",          :default => true
  end

  create_table "profiles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
  end

  add_index "roles", ["authorizable_id"], :name => "index_roles_on_authorizable_id"
  add_index "roles", ["authorizable_type"], :name => "index_roles_on_authorizable_type"
  add_index "roles", ["name", "authorizable_id", "authorizable_type"], :name => "index_roles_on_name_and_authorizable_id_and_authorizable_type", :unique => true
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id", "role_id"], :name => "index_roles_users_on_user_id_and_role_id", :unique => true
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "teams", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_columns", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.integer  "feed_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_company_tabs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "feed_info_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "follower"
    t.boolean  "is_aggregate"
  end

  create_table "user_feeds", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "category_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "feed_account_id"
    t.integer  "feed_info_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email_home"
    t.string   "email_work"
    t.string   "is_email_home_primary"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "country"
    t.string   "team"
    t.string   "sport"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login"
    t.boolean  "is_online"
    t.string   "remember_columns"
    t.string   "full_name"
    t.boolean  "is_public"
    t.string   "oauth_token"
    t.string   "oauth_secret"
    t.string   "remember_companies"
  end

  add_index "users", ["oauth_token"], :name => "index_users_on_oauth_token"

end
