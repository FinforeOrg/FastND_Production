class AddWindowTypeOnFeedAccounts < ActiveRecord::Migration
  def self.up
    add_column :feed_accounts,:window_type,:string
  end

  def self.down
    remove_column :feed_accounts,:window_type
  end
end
