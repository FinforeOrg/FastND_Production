class DeleteSomeFieldsInUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :google_login
    remove_column :users, :google_password
    remove_column :users, :twitter_home_login
    remove_column :users, :twitter_home_password
    remove_column :users, :twitter_work_login
    remove_column :users, :twitter_work_password
    remove_column :users, :linked_in_login
    remove_column :users, :linked_in_password
    remove_column :users, :facebook_login
    remove_column :users, :facebook_password
    add_column :users, :is_online, :boolean
  end

  def self.down
    add_column :users, :google_login, :string
    add_column :users, :google_password, :string
    add_column :users, :twitter_home_login, :string
    add_column :users, :twitter_home_password, :string
    add_column :users, :twitter_work_login, :string
    add_column :users, :twitter_work_password, :string
    add_column :users, :linked_in_login, :string
    add_column :users, :linked_in_password, :string
    add_column :users, :facebook_login, :string
    add_column :users, :facebook_password, :string
    remove_column :users, :is_online
  end
end
