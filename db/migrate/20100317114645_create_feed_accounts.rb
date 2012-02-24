class CreateFeedAccounts < ActiveRecord::Migration
  def self.up
    create_table :feed_accounts do |t|
      t.integer :user_id
      t.string  :name
      t.string  :category
      t.string  :account
      t.string  :password
      t.timestamps
    end
  end

  def self.down
    drop_table :feed_accounts
  end
end
