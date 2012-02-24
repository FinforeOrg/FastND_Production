class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      #AuthLogic Information
      t.string :email_home
      t.string :email_work
      t.string :is_email_home_primary
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.string :single_access_token
      t.string :perishable_token
      t.integer :login_count
      t.integer :failed_login_count
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string :current_login_ip
      t.string :last_login_ip
      #Social Networking information
      t.string :google_login
      t.string :google_password
      t.string :twitter_home_login
      t.string :twitter_home_password      
      t.string :twitter_work_login
      t.string :twitter_work_password
      t.string :linked_in_login
      t.string :linked_in_password
      t.string :facebook_login
      t.string :facebook_password
      #User Interests
      t.string :country
      t.string :geographic
      t.string :team
      t.string :sport
      t.string :profession
      t.string :industry

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end