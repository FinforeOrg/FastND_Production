class AddFeedAccountIdInKeywordColumns < ActiveRecord::Migration
  def self.up
    add_column :keyword_columns, :feed_account_id, :integer
  end

  def self.down
    remove_column :keyword_columns, :feed_account_id
  end
end
